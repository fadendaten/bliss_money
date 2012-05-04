# encoding: utf-8

require "spec_helper"

describe Money, "rounding" do
  
  describe "fraction" do
    it "should return the stored fraction correctly" do
      usd_00_1 = Money.new(12.48)
      usd_00_1.currency.fraction.should == 0.01
      chf_00_5 = Money.new(12.48, "CHF")
      chf_00_5.currency.fraction.should == 0.05
    end
    
    it "should return a rounded Money object" do
      usd_00_1 = Money.new(12.48)
      usd_00_1.rounded.should == Money.new(12.48)
      chf_00_5 = Money.new(12.48, "CHF")
      chf_00_5.rounded.should_not == Money.new(12.48, "CHF")
      chf_00_5.rounded.should == Money.new(12.50, "CHF")
    end
    
    it "should round the value based on set fraction of currency" do
      eur_0_01 = Money.new(12.43)
      eur_0_01.rounded.should == Money.new(12.43)
      
      eur_0_05 = Money.new(12.43)
      eur_0_05.currency.fraction = 0.05
      eur_0_05.rounded.should == Money.new(12.45)
      
      eur_0_10 = Money.new(12.43)
      eur_0_10.currency.fraction = 0.10
      eur_0_10.rounded.should == Money.new(12.40)
      
      eur_1_00 = Money.new(12.43)
      eur_1_00.currency.fraction = 1.00
      eur_1_00.rounded.should == Money.new(12.00)
    end
    
  end
  
end

