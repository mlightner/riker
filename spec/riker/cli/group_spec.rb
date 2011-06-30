require 'spec_helper'

describe Riker::CLI::Group do
  before :each do
    @group = Riker::CLI::Group.new(:hackers)
  end

  it { @group.should have_attr_reader :commands }

  describe "#initialize" do
    it "sets @name" do
      @group.instance_variable_get(:@name).should == :hackers
    end

    it "sets @commands to an empty Array" do
      @group.instance_variable_get(:@commands).should == []
    end
  end

  describe "#command" do
    it "appends a CLI::Command to @commands" do
      expect do
        @group.command :ddos
      end.to change { @group.commands.size }.by(1)

      @group.command :ddos
      cmd = @group.commands.assoc(:ddos)
      cmd.should have(2).items
      cmd[0].should == :ddos
      cmd[1].should be_a Riker::CLI::Command
    end
  end

  describe "#driver" do
    it "sets @driver with an argument" do
      @group.driver TestDriver.new
      @group.instance_variable_get(:@driver).should be_a TestDriver
    end

    it "gets @driver with no argument" do
      @group.instance_variable_set(:@driver, TestDriver.new)
      @group.driver.should be_a TestDriver
    end
  end

  describe "#help" do
    it "sets @help with an argument" do
      @group.help "HELP"
      @group.instance_variable_get(:@help).should == "HELP"
    end

    it "gets @help with no argument" do
      @group.instance_variable_set(:@help, "HELP")
      @group.help.should == "HELP"
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
