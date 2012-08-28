# encoding: utf-8
require 'money/money/arithmetic'
require 'money/money/formatting'

# Represents an amount of money in a given currency.
class Money
  include Comparable
  include Arithmetic
  include Formatting

  # The value of the money.
  #
  # @return [BigDecimal
  def amount
    @amount
  end

  # The currency the money is in.
  #
  # @return [Currency]
  attr_reader :currency

  # The +Money::Bank+ based object used to perform currency exchanges with.
  #
  # @return [Money::Bank::*]
  attr_reader :bank

  # Class Methods
  class << self
    # Each Money object is associated to a bank object, which is responsible
    # for currency exchange. This property allows you to specify the default
    # bank object. The default value for this property is an instance of
    # +Bank::VariableExchange.+ It allows one to specify custom exchange rates.
    #
    # @return [Money::Bank::*]
    attr_accessor :default_bank

    # The default currency, which is used when +Money.new+ is called without an
    # explicit currency argument. The default value is Currency.new("USD"). The
    # value must be a valid +Money::Currency+ instance.
    #
    # @return [Money::Currency]
    attr_accessor :default_currency

    # Use this to disable i18n even if it's used by other objects in your app.
    #
    # @return [true,false]
    attr_accessor :use_i18n

    # Use this to enable the ability to assume the currency from a passed symbol
    #
    # @return [true,false]
    attr_accessor :assume_from_symbol
  end


  # Set the default currency for creating new +Money+ object.
  self.default_currency = Currency.new("USD")

  # Default to using i18n
  self.use_i18n = true

  # Default to not using currency symbol assumptions when parsing
  self.assume_from_symbol = false

  # Create a new money object with value 0.
  #
  # @param [Currency, String, Symbol] currency The currency to use.
  #
  # @return [Money]
  #
  # @example
  #   Money.empty #=> #<Money @cents=0>
  def self.empty(currency = default_currency)
    Money.new(0, currency)
  end

  # Creates a new Money object of the given value, using the Canadian
  # dollar currency.
  #
  # @param [Integer] cents The cents value.
  #
  # @return [Money]
  #
  # @example
  #   n = Money.ca_dollar(100)
  #   n.cents    #=> 100
  #   n.currency #=> #<Money::Currency id: cad>
  def self.ca_dollar(cents)
    Money.new(cents, "CAD")
  end

  # Creates a new Money object of the given value, using the American dollar
  # currency.
  #
  # @param [Integer] cents The cents value.
  #
  # @return [Money]
  #
  # @example
  #   n = Money.us_dollar(100)
  #   n.cents    #=> 100
  #   n.currency #=> #<Money::Currency id: usd>
  def self.us_dollar(cents)
    Money.new(cents, "USD")
  end

  # Creates a new Money object of the given value, using the Euro currency.
  #
  # @param [Integer] cents The cents value.
  #
  # @return [Money]
  #
  # @example
  #   n = Money.euro(100)
  #   n.cents    #=> 100
  #   n.currency #=> #<Money::Currency id: eur>
  def self.euro(cents)
    Money.new(cents, "EUR")
  end
  
  
  # Creates a new Money object of +cents+ value in cents,
  # with given +currency+.
  #
  # Alternatively you can use the convenience
  # methods like {Money.ca_dollar} and {Money.us_dollar}.
  #
  # @param [Integer] cents The money amount, in cents.
  # @param [Currency, String, Symbol] currency The currency format.
  # @param [Money::Bank::*] bank The exchange bank to use.
  #
  # @return [Money]
  #
  # @example
  #   Money.new(100)
  #   #=> #<Money @cents=100 @currency="USD">
  #   Money.new(100, "USD")
  #   #=> #<Money @cents=100 @currency="USD">
  #   Money.new(100, "EUR")
  #   #=> #<Money @cents=100 @currency="EUR">
  #
  # @see Money.new_with_dollars
  #
  def initialize(amount, currency = Money.default_currency)
    @amount = BigDecimal(amount.to_s)
    @currency = Currency.wrap(currency)
  end

  # Returns the value of the money in dollars,
  # instead of in cents.
  #
  # @return [Float]
  #
  # @example
  #   Money.new(100).dollars           # => 1.0
  #   Money.new_with_dollars(1).dollar # => 1.0
  #
  # @see #to_f
  # @see #cents
  #
  def dollars
    to_f
  end

  # Return string representation of currency object
  #
  # @return [String]
  #
  # @example
  #   Money.new(100, :USD).currency_as_string #=> "USD"
  def currency_as_string
    currency.to_s
  end

  # Set currency object using a string
  #
  # @param [String] val The currency string.
  #
  # @return [Money::Currency]
  #
  # @example
  #   Money.new(100).currency_as_string("CAD") #=> #<Money::Currency id: cad>
  def currency_as_string=(val)
    @currency = Currency.wrap(val)
  end

  # Returns a Fixnum hash value based on the +cents+ and +currency+ attributes
  # in order to use functions like & (intersection), group_by, etc.
  #
  # @return [Fixnum]
  #
  # @example
  #   Money.new(100).hash #=> 908351
  def hash
    [amount.hash, currency.hash].hash
  end

  # Uses +Currency#symbol+. If +nil+ is returned, defaults to "¤".
  #
  # @return [String]
  #
  # @example
  #   Money.new(100, "USD").symbol #=> "$"
  def symbol
    currency.symbol || "¤"
  end

  # Common inspect function
  #
  # @return [String]
  def inspect
    "#<Money amount:#{amount} currency:#{currency}>"
  end

  # Returns the amount of money as a string.
  #
  # @return [String]
  #
  # @example
  #   Money.new(10.2368).to_s #=> "10.24"
  #   Money.new(10.2368).to_s :exact => true #=> "10.2368"
  def to_s(options = {})
    return amount.to_f.to_s if options[:exact]
    self.format(:symbol => false)
  end
  
  def with_currency(options = {})
    return self.format(:with_currency => true, :symbol => false) if options[:after] 
    return self.format(:with_currency => true, :symbol => false, :before => true)
  end

  # Return the amount of money as a BigDecimal.
  #
  # @return [BigDecimal]
  #
  # @example
  #   Money.us_dollar(100).to_d => BigDecimal.new("1.0")
  def to_d
    amount
  end
  
  # Conversation to +self+.
  #
  # @return [self]
  def to_money(given_currency = nil)
    given_currency = Currency.wrap(given_currency) if given_currency
    if given_currency.nil? || self.currency == given_currency
      self
    else
      exchange_to(given_currency)
    end
  end

  # Return the amount of money as a float. Floating points cannot guarantee
  # precision. Therefore, this function should only be used when you no longer
  # need to represent currency or working with another system that requires
  # decimals.
  #
  # @return [Float]
  #
  # @example
  #   Money.new(12.5).to_f => 12.5
  def to_f
    amount.to_f
  end
  
  def rounded(fraction = currency.fraction)
    fraction = 1 / fraction
    rounded_value = (BigDecimal.new (self.amount * fraction).round.to_s) / fraction
    Money.new(rounded_value.to_f, currency)
  end
  
end
