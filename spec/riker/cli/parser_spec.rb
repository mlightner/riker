require 'spec_helper'

describe Riker::CLI::Parser do
  it { Riker::CLI::Parser.should < OptionParser }
  it { should have_attr_accessor :options }
end
