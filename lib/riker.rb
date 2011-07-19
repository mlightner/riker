require 'optparse'

class Riker
  Version = VERSION = '0.0.0'

  module DSL
    def command(name, desc = nil, &block)
      command = Command.new(name, desc, self)
      command.instance_eval(&block)
      commands << command
      command
    end
    protected :command

    def parser_stack
      @parser_stack ||= []
    end
    protected :parser_stack

    def parser(&block)
      if block_given?
        parser_stack << block
      end
      option_parser
    end

    def build_parser!
      parser_stack.each do |block|
        block.call(option_parser)
      end
      option_parser
    end
  end

  class Command
    include DSL

    attr_reader :name, :parent, :description

    def initialize(name, description, parent)
      @name          = name
      @parent      = parent
      @description = description
      @action      = lambda { puts parser }
    end

    def id
      if parent.is_a?(Command)
        parent.id << name
      else
        [name]
      end
    end

    def build!
      parent.build! if parent.respond_to?(:build!)
      build_parser!
    end

    def respond_to?(sym, include_priv = false)
      super || parent.respond_to?(sym, include_priv)
    end

    def method_missing(sym, *args, &block)
      if parent.respond_to?(sym)
        parent.send(sym, *args, &block)
      else
        super
      end
    end

    def action(&block)
      @action = block if block_given?
    end

    def run_action!
      @action.call(self) if @action && @action.respond_to?(:call)
    end
  end

  class Parser < OptionParser
    def required_switches
      @required_switches ||= []
    end

    def required(key, *args, &block)
      unless required_switches.include?(key)
        required_switches << key
        on(*args, &block)
      end
    end
  end

  include DSL

  def initialize(argv = ARGV, &block)
    @argv = ARGV.dup
    @_lets ||= {}
    instance_eval(&block) if block_given?
    parse
  end

  def options
    @options ||= {}
  end

  def let(key, &block)
    @_lets[key] = block
  end

  def parse(argv = nil)
    argv_in, argv_out = (argv || @argv).dup, []

    until argv_in.empty? or cmd = find_command(*argv_in)
      argv_out.unshift argv_in.pop
    end

    cmd.build! if cmd

    argv_out
  end

  def find_commands(*keys)
    if keys.nil? || keys.empty?
      out = commands.reverse.select { |cmd| cmd.id.length == 1 }.uniq
    else
      out = commands.reverse.select do |cmd|
        if cmd.id.length > keys.length
          keys == cmd.id.slice(0, keys.length)
        end
      end
    end
    out unless out.empty?
  end

  def commands
    @commands ||= []
  end
  protected :commands

  def find_command(*keys)
    keys.map!(&:to_sym)
    commands.find { |cmd| cmd.id == keys }
  end
  protected :find_command

  def option_parser
    @option_parser ||= Parser.new(:auto)
  end
  protected :option_parser

  def respond_to?(sym, include_priv = false)
    super || @_lets.has_key?(sym)
  end

  def method_missing(sym, *args, &block)
    if @_lets.has_key?(sym)
      if @_lets[sym].respond_to?(:call)
        @_lets[sym].call
      else
        @_lets[sym]
      end
    else
      super
    end
  end
end
