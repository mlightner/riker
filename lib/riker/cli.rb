require 'riker/version'
require 'riker/exceptions'

module Riker
  class CLI
    autoload :Group,   "riker/cli/group"
    autoload :Command, "riker/cli/command"
    autoload :Switch,  "riker/cli/switch"
    autoload :Parser,  "riker/cli/parser"

    class << self
      def groups
        @groups ||= []
      end

      def group(name, &block)
        unless groups.assoc(name)
          group = CLI::Group.new(name)
          group.instance_eval(&block) if block_given?
          groups << [name, group]
          group
        end
      end

    end

    attr_reader :parser

    def initialize(argv = [])
      @command    = argv.shift
      @subcommand = argv.shift unless argv.first.to_s.match(/^--/)
      @argv       = argv
      @parser     = CLI::Parser.new
    end

    # Dispatches the CLI
    #
    # Looks for a CLI group named @command, then
    # tries to run @subcommand using the CLI group's #driver
    # method
    def dispatch!
    end

    def to_s
      @parser.to_s
    end
  end
end
