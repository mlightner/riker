require 'spec_helper'

describe Riker do
  before do
    @riker = Riker.new do
      command :holodeck do
        parser { |p| p.banner = 'Holodeck' }
        command :doors do
          parser { |p| p.banner = 'Holodeck doors' }
        end
      end
    end
  end

  describe "::Version" do
    it "has a valid format" do
      Riker::Version.should match /\d\.\d\.\d/
    end

    it "is accessible as VERSION" do
      Riker::Version.should equal Riker::VERSION
    end
  end

  it "should include DSL" do
    Riker.should include Riker::DSL
  end

  describe "#initialize" do
    it "instance_evals a block if given" do
      opt = nil
      Riker.new { opt = options }
      opt.should == @riker.options
    end
    it "sets @argv" do
      @riker.instance_variable_get(:@argv).should be_an Array
    end
    it "sets @_lets" do
      @riker.instance_variable_get(:@_lets).should be_a Hash
    end
  end

  describe "#options" do
    it "should be a hash" do
      @riker.options.should be_a Hash
    end
  end

  describe "#let" do
    it "should set @_lets[key] = block" do
      blk = lambda { :holodeck }
      @riker.let(:cmd, &blk)
      @riker.instance_variable_get(:@_lets)[:cmd].should eql(blk)
    end
  end

  describe "#parse" do
    it "should parse an array of args" do
      out = @riker.parse %w[holodeck doors open]
      out.should == %w[open]
    end
  end

  describe "#commands" do
    it "should be an Array" do
      @riker.instance_eval('commands').should be_an Array
    end
  end

  describe "#find_command" do
    context "with invalid key" do
      it "returns nil" do
        @riker.instance_eval { find_command :replicator }.should be_nil
      end
    end

    context "with valid keys" do
      context "with a single key" do
        it "returns a command" do
          cmd = @riker.instance_eval do
            find_command :holodeck
          end
          cmd.should be_a Riker::Command
          cmd.id.should == [:holodeck]
        end
      end

      context "with multiple keys" do
        it "returns a command" do
          cmd = @riker.instance_eval do
            find_command :holodeck, :doors
          end
          cmd.should be_a Riker::Command
          cmd.id.should == [:holodeck, :doors]
        end
      end
    end
  end

  describe "#current_command" do
    it "should be an Array" do
      @riker.instance_eval('current_command').should be_an Array
    end
  end

  describe "#option_parser" do
    it "should be an OptionParser" do
      @riker.instance_eval('option_parser').should be_an OptionParser
    end
  end

  describe "#respond_to" do
    before :each do
      @riker.let(:cmd) { :holodeck }
    end

    it "should return true if value from @_lets exists" do
      @riker.respond_to?(:cmd).should == true
    end

    it "should return false if the value doesn't exist in @_lets" do
      @riker.respond_to?(:i_am_fake).should == false
    end
  end

  describe "#method_missing" do
    before :each do
      @riker.let(:cmd) { :holodeck }
    end

    it "should return value from @_lets if it exists" do
      @riker.cmd.should == :holodeck
    end

    it "should raise NoMethodError @_lets doesn't include value" do
      expect { @riker.i_am_fake }.to raise_error NoMethodError
    end
  end

  context "::DSL" do
    describe "#command" do
      it "appends a Command to Riker#commands" do
        expect do
          @riker.instance_eval { command(:foo) {} }
        end.to change { @riker.instance_variable_get(:@commands).size }.by(1)
      end
    end
  end

  context "::Command" do
    before do
      @cmd = @riker.instance_eval { find_command :holodeck }
    end

    it { @cmd.should have_attr_reader :id }
    it { @cmd.should have_attr_reader :parent }

    it "should include DSL" do
      Riker::Command.should include Riker::DSL
    end

    describe "#initialize" do
      it "sets @id" do
        @cmd.instance_variable_get(:@id).should == [:holodeck]
      end

      it "sets @parent" do
        @cmd.instance_variable_get(:@parent).should eql(@riker)
      end
    end

    describe "#parser" do
      it "sets @parser" do
        blk = lambda { |p| p.banner = 'riker test' }
        @cmd.parser &blk
        @cmd.instance_variable_get(:@parser).should eql(blk)
      end
    end

    describe "#run!" do
      it "runs @parent.parser" do
        @cmd.parent.should_receive(:run!)
        @cmd.run!
      end

      it "calls @parser" do
        @cmd.instance_variable_get(:@parser).
          should_receive(:call).
          with(@riker.instance_eval('option_parser'))
        @cmd.run!
      end
    end

    describe "#respond_to?" do
      it "returns true if @parent.respond_to?" do
        @cmd.respond_to?(:options).should be_true
      end
    end

    describe "#method_missing" do
      it "tries to run the method in @parent" do
        @cmd.options.should eql(@riker.options)
      end

      it "raises method missing unless @parent.respond_to? method" do
        expect { @cmd.open_holodeck }.to raise_error NoMethodError
      end
    end
  end
end
