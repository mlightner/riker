require 'optparse'

class Riker
  Version = VERSION = '0.0.0'

  module DSL
    def command(name, &block)
      current_command << name
      command = Command.new(current_command.dup, self)
      command.instance_eval(&block)
      commands << command
      current_command.delete(name)
      command
    end
    protected :command
  end

  class Command
    include DSL

    attr_reader :id, :parent

    def initialize(id, parent)
      @id     = id
      @parent = parent
    end

    def parser(&block)
      @parser = block if block_given?
    end

    def run!
      parent.run! if parent.respond_to?(:run!)
      @parser.call(option_parser) if @parser
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
  end

  include DSL

  def initialize(&block)
    instance_eval(&block) if block_given?
  end

  def options
    @options ||= {}
  end

  def parse(argv)
    argv_in, argv_out = argv.dup, []

    until argv_in.empty? or cmd = find_command(*argv_in)
      argv_out.unshift argv_in.pop
    end

    cmd.run! if cmd

    argv_out
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

  def current_command
    @current_command ||= []
  end
  protected :current_command

  def option_parser
    @option_parser ||= OptionParser.new
  end
  protected :option_parser
end
