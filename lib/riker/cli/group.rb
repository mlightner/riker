module Riker
  class CLI::Group
    attr_reader :commands

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

    def driver(driver = nil)
      @driver = driver || @driver
    end

    def help(help = nil)
      @help = help || @help
    end

    def try_command(cmd, argv = [])
      if driver.respond_to?(cmd)
        driver.send(cmd, argv)
      else
        false
      end
    end
  end
end
