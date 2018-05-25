# frozen_string_literal: true

# class Wagon
class Wagon
  include CompanyName
  include Validation

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  protected

  def validate!
    raise 'Тип не может быть пустым' if @type.nil? || @type.empty?
  end
end
