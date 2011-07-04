module Riker
  class CLI::Group
    include CLI::DSL
    attr_reader :commands
    attr_setter :help

    def initialize(name)
      @name     = name
      @commands = []
    end

    def command(name, &block)
      command = CLI::Command.new(name)
      command.instance_eval(&block) if block_given?
      @commands << [name, command]
      command
    end

    def command_exists?(name)
      !! @commands.assoc(name)
    end

  end
end
