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

    def self.group_exists?(name)
      stack.any? { |s| s[:type] == :group && s[:name] == name }
    end

    def self.group(name, &block)
      unless group_exists?(name)
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

    def initialize(argv = ARGV.dup, &block)
      @command    = argv.shift
      @subcommand = argv.shift unless argv.first.to_s.match(/^--/)
      @argv       = argv

      self.class.instance_eval(&block) if block_given?
    end

    def group
      @group ||= self.class.find_stack_item(@command, :group)
    end

    def group?
      ! group.nil?
    end

    # Dispatches the CLI
    #
    # Looks for a CLI group named @command, then
    # tries to run @subcommand using the CLI group's #driver
    # method
    def dispatch!
    end
  end
end
