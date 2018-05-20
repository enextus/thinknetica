# frozen_string_literal: true

# module InstanceCounter
module InstanceCounter
  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send :include, InstanceMethods
  end

  # module ClassMethods
  module ClassMethods
    def instances_count
      @instances ||= 0
      @instances += 1
    end

    def instances
      @instances ||= 0
      @instances
    end
  end

  # module InstanceMethods
  module InstanceMethods
    private

    def register_instance
      self.class.instances_count
    end
  end
end
