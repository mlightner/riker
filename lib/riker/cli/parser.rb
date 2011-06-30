require 'optparse'

module Riker
  class CLI::Parser < OptionParser
    attr_accessor :options
  end
end
