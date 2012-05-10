require "spec_helper"

describe Money do
  
  describe "ActiveRecord::Base" do
    it "should have a has_money method" do
      ActiveRecord::Base.should respond_to :has_money
    end
  end
  
end