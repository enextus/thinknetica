# frozen_string_literal: true

# class Wagon
class Wagon
  include CompanyName
  include Validation

  attr_reader :capacity, :type, :free_capacity

  def initialize(capacity, type)
    @capacity = capacity
    @type = type
    validate!
    @free_capacity = @capacity
  end

  def loaded_capacity
    @capacity - @free_capacity
  end
end
