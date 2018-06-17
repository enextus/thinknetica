# frozen_string_literal: true

require_relative 'acсessors'

# class Test
class Test
  extend Accessors

  attr_accessor_with_history :my_attr, :a, :b, :c
  strong_attr_accessor :d, String

  protected

  def validate!
    raise 'Invalid number format!' if @d.class != String
  end
end
