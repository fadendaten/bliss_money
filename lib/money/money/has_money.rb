#encoding: UTF-8
class Money
  
  module HasMoney

    def self.included(base)
      base.extend ClassMethods    
    end

    module ClassMethods
      def has_money
        include InstanceMethods
      end

    end

    module InstanceMethods
      def self.included(base)

        # base.validates_presence_of :price_currency, :price_value, valid_from
        base.composed_of :money,
          :class_name => "Money",
          :mapping => [%w(price_value amount), %w(price_currency currency_as_string)],
          :constructor => Proc.new { |amount, currency| Money.new(amount || 0, currency || Money.default_currency) },
          :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
      end

      def to_s
        self.money.to_s
      end

      def exact
        self.money.to_f
      end

      def with_currency
        self.money.format(:symbol => false, :with_currency => true)
      end
      
      def money=(money)
        self.price_value = money.amount
        self.price_currency = money.currency
      end

    end
  end
end

ActiveRecord::Base.send :include, Money::HasMoney