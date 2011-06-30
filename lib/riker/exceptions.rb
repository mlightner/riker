module Riker
  class InvalidSwitchError < StandardError
    def initialize(name = nil)
      msg = "Invalid switch"
      msg << ", :#{name}" if name
      super msg
    end
  end

  class InvalidCommandError < StandardError
    def initialize(name = nil)
      msg = "Invalid command"
      msg << ", :#{name}" if name
      super msg
    end
  end
end
