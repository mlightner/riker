require 'spec_helper'

describe Riker do
  context "::Version" do
    it "has a valid format" do
      Riker::Version.should match /\d\.\d\.\d/
    end

    it "is accessible as VERSION" do
      Riker::Version.should equal Riker::VERSION
    end
  end
end
