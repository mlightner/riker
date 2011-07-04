module Riker
  class CLI::Command
    include CLI::DSL
    attr_reader :switches
    attr_setter :description
    attr_setter :action

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

    def parser
      @parser ||= CLI::Parser.new
    end

    def run_action!
      if action && action.respond_to?(:call)
        if action.parameters.size > 0
          action.call(@options)
        else
          action.call
        end
      end
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
