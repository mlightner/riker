require 'spec_helper'

describe Riker::CLI::Command do
  before :each do
    @cmd = Riker::CLI::Command.new(:test)
  end

  it { @cmd.should have_attr_reader :switches }

  describe "#initialize" do
    it "sets @name" do
      @cmd.instance_variable_get(:@name).should == :test
    end

    it "sets @switches to an empty Array" do
      @cmd.instance_variable_get(:@switches).should == []
    end

    it "sets @options to an empty Hash" do
      @cmd.instance_variable_get(:@options).should == {}
    end
  end

  describe "#switch" do
    it "requires a block", :pending => true do
      expect { @cmd.switch :test }.to raise_error /no block given/
    end

    it "appends to @switches" do
      expect do
        @cmd.switch :test do
          label 'test'
        end
      end.to change { @cmd.switches.size }.by(1)
    end
  end

  describe "#description" do
    it "sets @description with an argument" do
      desc = "My Cool Prog"
      @cmd.description desc
      @cmd.instance_variable_get(:@description).should == desc
    end

    it "gets @description with no arguement" do
      desc = "My Cooler Prog"
      @cmd.instance_variable_set(:@description, desc)
      @cmd.description.should == desc
    end
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
      @cmd.build_parser(parser)
      output = parser.to_s
      output.should match /Required parameters/
      output.should match /--id ID/
    end
  end
end
