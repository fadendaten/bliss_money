#encoding: UTF-8
class Money
  module HasMoney

    def self.included(base)
      base.extend ClassMethods    
    end

    module ClassMethods
      def act_as_price
        include InstanceMethods
      end

    end

    module InstanceMethods
      def self.included(base)

        base.validates_presence_of :price_currency, :price_value
        base.composed_of :price,
          :class_name => "Money",
          :mapping => [%w(price_value amount), %w(price_currency currency_as_string)],
          :constructor => Proc.new { |amount, currency| Money.new(amount || 0, currency || Money.default_currency) },
          :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
      end

      def with_currency
        self.to_s.format(:symbol => false, :with_currency => true)
      end
    end
  end
end

module ActiveRecord
  class Base
    include Money::HasMoney
  end
end