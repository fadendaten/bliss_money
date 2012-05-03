# Open +Numeric+ to add new method.
class Numeric

  # Converts this numeric into a +Money+ object in the given +currency+.
  #
  # @param [Currency, String, Symbol] currency
  #   The currency to set the resulting +Money+ object to.
  #
  # @return [Money]
  #
  # @example
  #   100.to_money                   #=> #<Money @cents=10000>
  #   100.37.to_money                #=> #<Money @cents=10037>
  #   BigDecimal.new('100').to_money #=> #<Money @cents=10000>
  #
  # @see Money.from_numeric
  #
  def to_money(currency = nil)
    Money.new(self, currency || Money.default_currency)
  end

end

# Open +Symbol+ to add new methods.
class Symbol

  # Converts the current symbol into a +Currency+ object.
  #
  # @return [Money::Currency]
  #
  # @raise [Money::Currency::UnknownCurrency]
  #   If this String reference an unknown currency.
  #
  # @example
  #   :ars.to_currency #=> #<Money::Currency id: ars>
  #
  def to_currency
    Money::Currency.new(self)
  end

end
