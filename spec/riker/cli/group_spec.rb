require 'spec_helper'

describe Riker::CLI::Group do
  before :each do
    @group = Riker::CLI::Group.new(:simulation)
  end

  it { @group.should have_attr_reader :commands }
  it { @group.should get_or_set :help }

  describe "#initialize" do
    it "sets @name" do
      @group.instance_variable_get(:@name).should == :simulation
    end

    it "sets @commands to an empty Array" do
      @group.instance_variable_get(:@commands).should == []
    end
  end

  describe "#command" do
    it "appends a CLI::Command to @commands" do
      expect do
        @group.command :load
      end.to change { @group.commands.size }.by(1)

      @group.command :load
      cmd = @group.commands.assoc(:load)
      cmd.should have(2).items
      cmd[0].should == :load
      cmd[1].should be_a Riker::CLI::Command
    end
  end

  describe "#command_exists?" do
    context "with valid command" do
      it do
        @group.command :load
        @group.command_exists?(:load).should == true
      end
    end
    context "with invalid command" do
      it { @group.command_exists?(:not_a_command).should == false }
    end
  end
end
