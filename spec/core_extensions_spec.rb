require "spec_helper"

describe Money, "core extensions" do

  describe Numeric do
    describe "#to_money" do
      it "work as documented" do
        money = 1234.to_money
        money.amount.should == 1234_00
        money.currency.should == Money.default_currency

        money = 100.37.to_money
        money.amount.should == 100_37
        money.currency.should == Money.default_currency

        money = BigDecimal.new('1234').to_money
        money.amount.should == 1234_00
        money.currency.should == Money.default_currency
      end

      it "accepts optional currency" do
        1234.to_money('USD').should == Money.new(123400, 'USD')
        1234.to_money('EUR').should == Money.new(123400, 'EUR')
      end

      it "respects :subunit_to_unit currency property" do
        10.to_money('USD').should == Money.new(10, 'USD')
        10.to_money('CHF').should == Money.new(10, 'CHF')
        10.to_money('EUR').should == Money.new(10, 'EUR')
      end

      specify "GH-15" do
        amount = 555.55.to_money
        amount.should == Money.new(55555)
      end
    end
  end

  describe Symbol do
    describe "#to_currency" do
      it "converts Symbol to Currency" do
        :usd.to_currency.should == Money::Currency.new("USD")
        :chf.to_currency.should == Money::Currency.new("CHF")
      end

      it "is case-insensitive" do
        :EUR.to_currency.should == Money::Currency.new("EUR")
      end

      it "raises Money::Currency::UnknownCurrency with unknown Currency" do
        expect { :XXX.to_currency }.to raise_error(Money::Currency::UnknownCurrency)
        expect { :" ".to_currency }.to raise_error(Money::Currency::UnknownCurrency)
      end
    end
  end

end
