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

    def build_parser(opt)
      required = @switches.select { |name, switch| switch.required? }
      optional = @switches - required

      if required.size > 0
        opt.separator "\nRequired parameters"
        required.each { |name, switch| opt.on(*switch.to_opt) }
      end

      if optional.size > 0
        opt.separator "\nOptional parameters"
        optional.each { |name, switch| opt.on(*switch.to_opt) }
      end
      opt
    end

  end
end
