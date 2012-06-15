# encoding: utf-8

require "spec_helper"

describe Money do

  describe ".new" do
    it "does not round the given amount to an integer" do
      Money.new(1.00, "USD").amount.should == 1.00
      Money.new(1.01, "USD").amount.should == 1.01
      Money.new(1.50, "USD").amount.should == 1.50
    end
  end

  describe "#amount" do
    it "returns the amount of amount" do
      Money.new(1_00).amount.should == 1_00
    end

    it "stores amount as an BigDecimal regardless of what is passed into the constructor" do
      [ Money.new(1), 1.to_money, 1.00.to_money, BigDecimal('1.00').to_money ].each do |m|
        m.amount.should == 1
        m.amount.should be_a(BigDecimal)
      end
    end
  end
  

  describe "#dollars" do
    it "returns the amount of amount as dollars" do
      Money.new(1_00).dollars.should == 1_00
    end

    it "respects :subunit_to_unit currency property" do
      Money.new(1_00,  "USD").dollars.should == 1_00
      Money.new(1_000, "EUR").dollars.should == 1_000
      Money.new(1,     "CHF").dollars.should == 1
    end

    it "does not loose precision" do
      Money.new(100_37).dollars.should == 100_37
    end
  end

  describe "#currency" do
    it "returns the currency object" do
      Money.new(1_00, "USD").currency.should == Money::Currency.new("USD")
    end
  end

  describe "#currency_as_string" do
    it "returns the iso_code of the currency object" do
      Money.new(1_00, "USD").currency_as_string.should == "USD"
      Money.new(1_00, "EUR").currency_as_string.should == "EUR"
    end
  end

  describe "#currency_as_string=" do
    it "sets the currency object using the provided string" do
      money = Money.new(100_00, "USD")
      money.currency_as_string = "EUR"
      money.currency.should == Money::Currency.new("EUR")
    end
  end

  describe "#hash=" do
    it "returns the same value for equal objects" do
      Money.new(1_00, "EUR").hash.should == Money.new(1_00, "EUR").hash
      Money.new(2_00, "USD").hash.should == Money.new(2_00, "USD").hash
      Money.new(1_00, "EUR").hash.should_not == Money.new(2_00, "EUR").hash
      Money.new(1_00, "EUR").hash.should_not == Money.new(1_00, "USD").hash
      Money.new(1_00, "EUR").hash.should_not == Money.new(2_00, "USD").hash
    end

    it "can be used to return the intersection of Money object arrays" do
      intersection = [Money.new(1_00, "EUR"), Money.new(1_00, "USD")] & [Money.new(1_00, "EUR")]
      intersection.should == [Money.new(1_00, "EUR")]
    end
  end

  describe "#symbol" do
    it "works as documented" do
      currency = Money::Currency.new("EUR")
      currency.should_receive(:symbol).and_return("€")
      Money.empty(currency).symbol.should == "€"

      currency = Money::Currency.new("EUR")
      currency.should_receive(:symbol).and_return(nil)
      Money.empty(currency).symbol.should == "¤"
    end
  end

  describe "#to_s" do
    it "works as documented" do
      Money.new(1000.34).to_s.should == "1000.34"
      Money.new(400.80).to_s.should == "400.80"
      Money.new(-23743).to_s.should == "-23743.00"
    end

    it "respects :exact option" do
      Money.new(10.1354, "CHF").to_s.should == "10.15"
      Money.new(10.1354, "CHF").to_s(:exact => true).should == "10.1354"
    end
  end

  describe "#to_d" do
    it "works as documented" do
      decimal = Money.new(10_00).to_d
      decimal.should be_a(BigDecimal)
      decimal.should == 1000.0
    end

    it "respects :subunit_to_unit currency property" do
      decimal = Money.new(10_00, "CHF").to_d
      decimal.should be_a(BigDecimal)
      decimal.should == 1000.0
    end

    it "works with float :subunit_to_unit currency property" do
      money = Money.new(10_00, "EUR")
      money.currency.stub(:subunit_to_unit).and_return(1000.0)

      decimal = money.to_d
      decimal.should be_a(BigDecimal)
      decimal.should == 1000.0
    end
  end

  describe "#to_f" do
    it "works as documented" do
      Money.new(10_00).to_f.should == 1000.0
    end

    it "respects :subunit_to_unit currency property" do
      Money.new(10_00, "CHF").to_f.should == 1000.0
    end
  end

  describe "#to_money" do
    it "works as documented" do
      money = Money.new(10_00, "USD")
      money.should == money.to_money
      money.should == money.to_money("USD")
      # money.bank.should_receive(:exchange_with).with(Money.new(10_00, Money::Currency.new("USD")), Money::Currency.new("EUR")).and_return(Money.new(200_00, Money::Currency.new('EUR')))
      # money.to_money("EUR").should == Money.new(200_00, "EUR")
    end
  end
  
  describe "#with_currecny" do
    it "returns the currency and a the value in a nice way" do
      money = Money.new(10.30, "CHF")
      money.with_currency.should == "CHF 10.30"
    end
  end

end

