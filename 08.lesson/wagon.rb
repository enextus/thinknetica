# frozen_string_literal: true

# class Wagon
class Wagon
  include CompanyName
  include Validation

  attr_reader :type, :capacity

  def initialize(capacity, type)
    @capacity = capacity
    validate!
    @type = type
  end

  protected

  def validate!
    raise 'Параметр не может быть пустым, повторите ввод!' if @capacity.nil? || @capacity.empty?
    raise 'Только положительное числовое значение, повторите ввод!' if @capacity !~ /^[0-9]+$/
  end
end
