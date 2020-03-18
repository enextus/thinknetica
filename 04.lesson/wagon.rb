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
    raise 'Номер не может быть пустым' unless ["cargo", "pass"].include?(@type)

    true
  end
end
