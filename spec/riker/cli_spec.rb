require 'spec_helper'

describe Riker::CLI do
  before :all do
    Riker::CLI.group :simulation
    Riker::CLI.command :status
  end

  before :each do
    @cli = Riker::CLI.new %w[simulation load picard1]
  end

  describe "::stack" do
    it { @cli.class.stack.should be_an Array }
  end

  describe "::group_exists?" do
    it "returns true if the group exists in ::stack" do
      @cli.class.group_exists?(:simulation).should == true
    end

    it "returns false if the group doesn't exist in ::stack" do
      @cli.class.group_exists?(:ten_forward).should == false
    end
  end

  describe "::command_exists?" do
    it "returns true if the command exists in ::stack" do
      @cli.class.command_exists?(:status).should == true
    end

    it "returns false if the command doesn't exist in ::stack" do
      @cli.class.command_exists?(:self_destruct).should == false
    end
  end

  describe "::find_stack_item" do
    it "returns a group from ::stack" do
      group = @cli.class.find_stack_item(:simulator, :group)
      group.should be_a Hash
      group[:name].should == :simulator
      group[:type].should == :group
      group[:item].should be_a Riker::CLI::Group
    end

    it "returns a command from ::stack" do
      command = @cli.class.find_stack_item(:status, :command)
      command.should be_a Hash
      command[:name].should == :status
      command[:type].should == :command
      command[:item].should be_a Riker::CLI::Command
    end
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
