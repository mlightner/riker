module Riker
  class CLI::Command
    attr_reader :switches

    def initialize(name)
      @name     = name
      @switches = []
      @options  = {}
    end

    def switch(name, &block)
      switch = CLI::Switch.new(name)
      switch.instance_eval(&block) if block_given?
      @switches << [name, switch]
      switch
    end

    def description(desc = nil)
      @description = desc || @description
    end

    def parser
      @parser ||= CLI::Parser.new
    end

    def build_parser
      required = @switches.select { |name, switch| switch.required? }
      optional = @switches - required

      if required.size > 0
        parser.separator "\nRequired parameters"
        required.each { |name, switch| parser.on(*switch.to_opt) }
      end

      if optional.size > 0
        parser.separator "\nOptional parameters"
        optional.each { |name, switch| parser.on(*switch.to_opt) }
      end
    end

  end
end
