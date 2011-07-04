require 'spec_helper'

describe Riker::CLI::Command do
  before :each do
    @cmd = Riker::CLI::Command.new(:load)
  end

  it { @cmd.should have_attr_reader :switches }

  describe "#initialize" do
    it "sets @name" do
      @cmd.instance_variable_get(:@name).should == :load
    end

    it "sets @switches to an empty Array" do
      @cmd.instance_variable_get(:@switches).should == []
    end

    it "sets @options to an empty Hash" do
      @cmd.instance_variable_get(:@options).should == {}
    end
  end

  describe "#switch" do
    it "appends to @switches" do
      expect do
        @cmd.switch :simulation_id do
          label 'Simulation ID'
        end
      end.to change { @cmd.switches.size }.by(1)
    end
  end

  describe "#parser" do
    it { @cmd.parser.should be_a Riker::CLI::Parser }

    it "sets @parser.program_name"
  end

  describe "#build_parser" do
    it "builds the OptionParser" do
      @cmd.switch :id do
        flag '--id ID'
        label 'ID'
        type Integer
        required
      end

      parser = OptionParser.new
      @cmd.build_parser
      output = @cmd.parser.to_s
      output.should match /Required parameters/
      output.should match /--id ID/
    end
  end

  describe "#run_action!" do
    before :each do
      $stdout.should_receive(:puts)
    end
    it "runs the action with param" do
      @cmd.action(lambda {|opt| puts "Hello" })
      @cmd.run_action!
    end
    it "runs the action with no param" do
      @cmd.action(lambda {puts "Hello" })
      @cmd.run_action!
    end
  end
end
