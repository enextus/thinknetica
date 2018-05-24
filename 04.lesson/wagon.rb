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
    raise 'Номер не может быть пустым' if @type.nil? || @type.empty?
    true
  end
end
