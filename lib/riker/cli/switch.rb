module Riker
  class CLI::Switch
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def flag(flag = nil)
      @flag = flag || @flag
    end

    def label(label = nil)
      @label = label || @label
    end

    def type(type = nil)
      @type = type || @type
    end

    def block(block = nil)
      @block = block || @block
    end

    def required
      @required = true
    end

    def required?
      !! @required
    end

    def to_opt
      [].tap do |a|
        a << flag  if flag
        a << label if label
        a << type  if type
        a << block if block
      end
    end
  end
end
