require 'spec_helper'

describe Riker::CLI do
  before :each do
    @cli = Riker::CLI.new %w[simulation load picard1]
  end

  describe "::StackItem" do
    before :all do
      @item = Riker::CLI::StackItem.new
    end
    [:name, :type, :item].each do |k|
      it { @item.should have_attr_accessor k }
    end
  end

  describe "::stack" do
    it { @cli.class.stack.should be_an Array }
  end

  describe "::find_stack_item" do
    it "returns a group from ::stack" do
      @cli.class.group :locks
      group = @cli.class.find_stack_item(:locks, :group)
      group.should equal @cli.class.stack.last
    end

    it "returns a command from ::stack"
  end

  describe "::group" do
    it "appends the group to ::stack" do
      expect do
        @cli.class.group :doors
      end.to change { @cli.class.stack.size }.by(1)
    end

    it "doesn't append if ::stack include group" do
      expect do
        @cli.class.group :doors
      end.to_not change { @cli.class.stack.size }
    end
  end

  describe "#initialize" do
    it "sets @command" do
      @cli.instance_variable_get(:@command).should == 'simulation'
    end

    it "sets @subcommand" do
      @cli.instance_variable_get(:@subcommand).should == 'load'
    end


    it "sets @argv" do
      argv = @cli.instance_variable_get(:@argv)
      argv.should have(1).item
      argv.first.should == 'picard1'
    end
  end

  describe "#dispatch!" do
    it "dispatches the CLI"
  end

  describe "#to_s" do
    it "prints the CLI"
  end

end
