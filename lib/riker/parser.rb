require 'optparse'

module Riker
  class Parser < OptionParser
    # Check if a group exists in #riker_stack
    def group_exists?(name)
      riker_stack.any? { |s| s[:type] == :group && s[:name] == name }
    end

    # Appends a group to #riker_stack
    def group(name, &block)
      opt = {
        :type => :group,
        :name => name
      }
      opt.merge!(:proc => block) if block_given?
      riker_stack << opt
    end

    # Check if a command exists in #riker_stack
    def command_exists?(name)
      riker_stack.any? { |s| s[:type] == :command && s[:name] == name }
    end

    # Appends a command to #riker_stack
    def command(name, &block)
      opt = {
        :type => :command,
        :name => name
      }
      opt.merge!(:proc => block) if block_given?
      riker_stack << opt
    end

    # Private: parses argv to determine if there is a group or command present
    # in #riker_stack, then passes on argv to OptionParser#parse_in_order
    def parse_in_order(argv = default_argv, setter = nil, &nonopt)  # :nodoc:
      super(argv, setter, &nonopt)
    end
    private :parse_in_order

    # Private: riker_stack will contain all groups/commands added to
    # the parser
    #
    # It is an Array of Hashes with keys :type, :name, :proc
    def riker_stack
      @riker_stack ||= []
    end
    private :riker_stack
  end
end
