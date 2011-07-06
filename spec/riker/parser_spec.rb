require 'spec_helper'

describe Riker::Parser do
  it { Riker::Parser.should be < OptionParser }

  before :each do
    @parser = Riker::Parser.new
  end

  describe "#group_exists?" do
    before :each do
      @parser.instance_eval('riker_stack') << {
        :type => :group,
        :name => :test
      }
    end
    context "when group exists" do
      it { @parser.group_exists?(:test).should be_true }
    end

    context "when group doesnt exist" do
      it { @parser.group_exists?(:da_bears).should be_false }
    end
  end

  describe "#group" do
    it "appends a Hash to #riker_stack" do
      expect do
        @parser.group :test
      end.to change { @parser.instance_eval('riker_stack').size }.by(1)
    end
  end

  describe "#command_exists?" do
    before :each do
      @parser.instance_eval('riker_stack') << {
        :type => :command,
        :name => :test
      }
    end
    context "when command exists" do
      it { @parser.command_exists?(:test).should be_true }
    end

    context "when command doesnt exist" do
      it { @parser.command_exists?(:da_bears).should be_false }
    end
  end

  describe "#command" do
    it "appends a Hash to #riker_stack" do
      expect do
        @parser.command :test
      end.to change { @parser.instance_eval('riker_stack').size }.by(1)
    end
  end

  describe "#riker_stack" do
    it "should be private" do
      expect do
        @parser.riker_stack
      end.to raise_error /private method `riker_stack' called/
    end
    it { @parser.instance_eval('riker_stack').should be_a Array }
  end

  describe "#parse_in_order" do
    it "calls super"
    it "parses argv"
  end
end

