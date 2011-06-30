require 'riker/version'
require 'riker/exceptions'

module Riker
  class CLI
    autoload :Group,   "riker/cli/group"
    autoload :Command, "riker/cli/command"
    autoload :Switch,  "riker/cli/switch"
    autoload :Parser,  "riker/cli/parser"


    def self.stack
      @stack ||= []
    end

    def self.find_stack_item(name, type)
      if name && type
        stack.detect do |s|
          s[:type] == type.to_sym && s[:name] = name.to_sym
        end
      end
    end

    def self.group(name, &block)
      unless stack.any? { |s| s[:type] == :group && s[:name] == name }
        group = CLI::Group.new(name)
        group.instance_eval(&block) if block_given?
        stack << {
          :name => name,
          :type => :group,
          :item => group
        }
        group
      end
    end

    attr_reader :parser

    def initialize(argv = [])
      @command    = argv.shift
      @subcommand = argv.shift unless argv.first.to_s.match(/^--/)
      @argv       = argv
    end

    # Dispatches the CLI
    #
    # Looks for a CLI group named @command, then
    # tries to run @subcommand using the CLI group's #driver
    # method
    def dispatch!
    end

    def to_s
      inspect
    end
  end
end
