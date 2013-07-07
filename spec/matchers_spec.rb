require 'rspec'
require './lib/type-enforcer/base.rb'
require './lib/type-enforcer/matchers.rb'

using TypeEnforcer
describe TypeEnforcer do
  describe String do
    describe "#numeric?" do
      it "returns true if a string is a number" do
        '1234'.numeric?.should be_true
        '1234.56'.numeric?.should be_true
        '1234.'.numeric?.should be_false
        'asdf'.numeric?.should be_false
      end
    end

    describe "#fixnum?" do
      it "returns true if a string is a fixnum" do
        '1234'.fixnum?.should be_true
        '1234.56'.fixnum?.should be_false
        'asdf'.fixnum?.should be_false
      end
    end

    describe "#blank?" do
      it "returns true if a string is empty" do
        ''.blank?.should be_true
        '   '.blank?.should be_true
        "\n\t ".blank?.should be_true
        ' a '.blank?.should be_false
        'abc'.blank?.should be_false
      end
    end
  end

  describe Numeric do
    describe "#whole?" do
      it "returns true if a number is whole" do
        123.whole?.should be_true
        123.0.whole?.should be_true
        123.4.whole?.should be_false
      end
    end
  end
end