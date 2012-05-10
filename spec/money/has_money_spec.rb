require "spec_helper"

describe Money do
  
  describe "ActiveRecord::Base" do
    it "should have a has_money method" do
      ActiveRecord::Base.should respond_to :act_as_price
    end
  end
  
end