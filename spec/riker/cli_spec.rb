require 'spec_helper'

describe Riker::CLI do
  before :each do
    @cli = Riker::CLI.new %w[simulation load picard1]
  end

  describe "::groups" do
    it { @cli.class.groups.should be_an Array }
  end

  describe "::group" do
    it "appends the group to ::groups" do
      expect do
        @cli.class.group :doors
      end.to change { @cli.class.groups.size }.by(1)
    end

    it "doesn't append if ::groups include group" do
      expect do
        @cli.class.group :doors
      end.to_not change { @cli.class.groups.size }
    end
  end

  describe "#initialize" do
    it "sets @command" do
      @cli.instance_variable_get(:@command).should == 'simulation'
    end

    it "sets @subcommand" do
      @cli.instance_variable_get(:@subcommand).should == 'load'
    end

    it "sets @parser" do
      @cli.instance_variable_get(:@parser).should be_a Riker::CLI::Parser
    end

    it "sets @parser.program_name"

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
    it "delegates to @parser.to_s" do
      @cli.to_s.should == @cli.parser.to_s
    end
  end
end
