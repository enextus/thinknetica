# frozen_string_literal: true

# class TestValidate
class TestValidate
  extend Accessors
  include Validation

  attr_accessor_with_history :name, :number

  validate :name, :type, String
  validate :name, :presence
  validate :number, :format, /^[a-z\d]{3}-?[a-z\d]{2}$/i, 'XXX-XX or XXXXX'

  def initialize(name, number)
    @name = name
    @number = number
    validate!
  end
end
