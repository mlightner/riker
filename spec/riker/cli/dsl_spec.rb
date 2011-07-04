require 'spec_helper'

class TestClass
  include Riker::CLI::DSL
  attr_setter :name
end

describe Riker::CLI::DSL do
  before :each do
    @base = TestClass.new
  end

  context "when included" do
    context "extends ClassMethods" do
      Riker::CLI::DSL::ClassMethods.instance_methods(false).each do |method|
        it { @base.class.should respond_to method }
      end
    end

    context "includes InstanceMethods" do
      Riker::CLI::DSL::InstanceMethods.instance_methods(false).each do |method|
        it { @base.should respond_to? method }
      end
    end
  end

  describe "::attr_setter" do
    it "gets attr" do
      @base.instance_variable_set(:@name, 'Laforge')
      @base.name.should == 'Laforge'
    end
    it "sets attr" do
      @base.name 'Laforge'
      @base.instance_variable_get(:@name).should == 'Laforge'
    end
  end
end
