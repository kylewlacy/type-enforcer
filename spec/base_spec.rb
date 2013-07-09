require 'rspec'
require './lib/type-enforcer/base.rb'

module Helpers
  class TestError < StandardError; end

  def is_numeric?(string = nil)
    !(/^\d+$/ =~ string).nil?
  end

  class TestBlank
    def initialize(string = '')
      @string = string
    end

    def empty?
      !(/^\s*$/ =~ @string).nil?
    end
  end
end

using TypeEnforcer
include Helpers
describe TypeEnforcer do
  describe "#enforce" do
    it "states whether or not an object is a type" do
      'asdf'.enforce(String).should == 'asdf'
      :asdf.enforce(String).should be_nil
      1234.enforce(String).should be_nil
    end

    it "states whether or not an object meets a condition" do
      '1234'.enforce(:is_numeric?).should == '1234'
      '123A'.enforce(:is_numeric?).should be_nil
    end
  end

  describe "#enforce!" do
    it "ensures an object meets a condition" do
      'asdf'.enforce!(String).should == 'asdf'
      expect { :asdf.enforce!(String) }.to raise_error(TypeEnforcer::NotFulfilledError)

      '1234'.enforce!(:is_numeric?).should == '1234'
      expect { '123A'.enforce!(:is_numeric?) }.to raise_error(TypeEnforcer::NotFulfilledError)
    end
  end

  describe "#acts_as?" do
    it "returns if an object is a given type" do
      '1234'.acts_as?(String).should be_true
      '1234'.acts_as?(Symbol).should_not be_true
    end
  end

  describe "#present?" do
    it "returns if an object is present" do
      '1234'.present?.should be_true
      nil.present?.should_not be_true
    end
  end

  describe "#present!" do
    it "ensures an object is present" do
      '1234'.present!.should == '1234'
      expect { nil.present! }.to raise_error(TypeEnforcer::NotPresentError)
    end
  end

  describe "#try" do
    it "calls a method on an object if possible" do
      '1234'.try(:split, '2').should == ['1', '34']
      ['1', '2', '3', '4'].try(:split, '2').should be_nil
    end

    it "tries to run a block" do
      '1234'.try {|s| s.to_i + 1}.should == 1235
      ['1', '2', '3', '4'].try  {|a| a.split << 5 }.should be_nil
    end

    it "rescues specified errors" do
      1234.try(:to_s, 37).should be_nil
      expect do
        1234.try(:to_s, 37, rescues: NoMethodError)
      end.to raise_error(ArgumentError)
    end
  end

  describe "#blank?" do
    it "states if an object is empty" do
      ''.blank?.should be_true
      [].blank?.should be_true
      nil.blank?.should be_true

      TestBlank.new('').blank?.should be_true
      TestBlank.new('   ').blank?.should be_true
      TestBlank.new('  a  ').blank?.should be_false
    end
  end
end