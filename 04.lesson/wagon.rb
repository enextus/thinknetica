# frozen_string_literal: true

# class Wagon
class Wagon
  include CompanyName

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end

  def valid?
    validate!
    rescue
      false
  end

  protected

  def validate!
    arr = %w[cargo pass]
    raise 'Неверный тип поезда!' unless arr.include?(@type)

    true
  end
end
