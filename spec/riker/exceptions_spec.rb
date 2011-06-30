require 'spec_helper'

describe Riker::InvalidSwitchError do
  context "without an argument" do
    it do
      expect do
        raise Riker::InvalidSwitchError
      end.to raise_error /^Invalid switch$/
    end
  end

  context "with an argument" do
    it do
      expect do
        raise Riker::InvalidSwitchError, :bad
      end.to raise_error /^Invalid switch, :bad$/
    end
  end
end

describe Riker::InvalidCommandError do
  context "without an argument" do
    it do
      expect do
        raise Riker::InvalidCommandError
      end.to raise_error /^Invalid command$/
    end
  end

  context "with an argument" do
    it do
      expect do
        raise Riker::InvalidCommandError, :bad
      end.to raise_error /^Invalid command, :bad$/
    end
  end
end
