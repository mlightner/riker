require 'spec_helper'

describe Riker::CLI::Switch do
  before :each do
    @switch = Riker::CLI::Switch.new :test
  end

  it { @switch.should have_attr_reader :name }

  describe "#initialize" do
    it "sets @name" do
      @switch.instance_variable_get(:@name).should == :test
    end
  end

  describe "#required" do
    it "sets @required = true" do
      @switch.required
      @switch.instance_variable_get(:@required).should == true
    end
  end

  describe "#required?" do
    it "returns true if @required is true" do
      @switch.required
      @switch.required?.should == true
    end

    it "returns false if @required is not true" do
      @switch.required?.should == false
    end
  end

  it { @switch.should get_or_set :flag }
  it { @switch.should get_or_set :label }
  it { @switch.should get_or_set :type }

end
