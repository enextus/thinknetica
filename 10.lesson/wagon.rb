# frozen_string_literal: true

# class Wagon
class Wagon
  include CompanyName
  include Validation

  attr_reader :type, :capacity, :free_capacity

  def initialize(capacity, type)
    @capacity = capacity
    validate!
    @type = type
    @free_capacity = @capacity
  end

  def loaded_capacity
    @capacity - @free_capacity
  end

  protected

  def validate!
    raise 'Invalid format, please try again!' unless @capacity.positive?
  end
end
