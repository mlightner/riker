require 'spec_helper'

describe Riker::CLI::Group do
  before :each do
    @group = Riker::CLI::Group.new(:simulation)
  end

  it { @group.should have_attr_reader :commands }
  it { @group.should get_or_set :help }
  it { @group.should get_or_set :driver }

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

  describe "#try_command" do
    before :each do
      @group.driver TestDriver.new
    end

    it "runs runs the command if driver responds to cmd" do
      @group.try_command(:say_my_name).should == :test_driver
    end

    it "returns false if driver does not respond to cmd" do
      @group.try_command(:i_am_not_a_method).should == false
    end
  end

end
