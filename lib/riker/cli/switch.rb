module Riker
  class CLI::Switch
    include CLI::DSL
    attr_reader :name
    attr_setter :flag
    attr_setter :label
    attr_setter :type
    attr_setter :action

    def initialize(name)
      @name = name
    end

    def required
      @required = true
    end

    def required?
      !! @required
    end

    def to_opt
      [].tap do |a|
        a << flag   if flag
        a << label  if label
        a << type   if type
        a << action if action
      end
    end
  end
end
