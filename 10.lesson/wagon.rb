# frozen_string_literal: true

# class Wagon
class Wagon
  extend Accessors
  include CompanyName
  include Validation

  # аьтоматически добавляются во все экземляра класса
  attr_reader :capacity, :type, :free_capacity
  attr_accessor_with_history :color
  strong_attr_accessor :levels, Integer

  def initialize(capacity, type)
    @capacity = capacity
    @type = type
    validate!
    @free_capacity = @capacity
    register_instance
  end

  def loaded_capacity
    @capacity - @free_capacity
  end
end
