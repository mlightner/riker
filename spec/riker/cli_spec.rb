require 'spec_helper'

describe Riker::CLI do
  before :each do
    @cli = Riker::CLI.new %w[simulation load picard1]
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

  describe "#group" do
    it "sets @group to a ::stack item" do
      group = @cli.group
      group.should be_a Hash
      group[:type].should == :group
      group[:name].should == :simulation
      group[:item].should be_a Riker::CLI::Group
    end
  end

  describe "#group?" do
    it "returns true if @group" do
      @cli.group?.should == true
    end

    it "returns false if @group.nil?" do
      @cli.instance_variable_set(:@group, nil)
      @cli.instance_variable_set(:@command, nil)
      @cli.group?.should == false
    end
  end

end
