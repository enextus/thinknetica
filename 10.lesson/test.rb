# frozen_string_literal: true

require_relative 'accessors'

# class Test
class Test
  extend Accessors

  attr_accessor_with_history :a, :b, :c
  strong_attr_accessor :d, String
end
