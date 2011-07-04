module Riker
  module CLI::DSL
    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def attr_setter(*attrs)
        attrs.each do |attr|
          class_eval <<-CLASS, __FILE__, __LINE__
            def #{attr}(val = nil)
              @#{attr} = val || @#{attr}
            end
          CLASS
        end
      end
    end

    module InstanceMethods

    end
  end
end
