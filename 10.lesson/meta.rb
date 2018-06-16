# frozen_string_literal: true

# module Accessors
module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)

        @arr << value
        @history[var_name] = @arr

        define_singleton_method("#{name}_history".to_sym) { @arr }
      end
    end
  end
end

# class Test
class Test
  extend Accessors

  def initialize
    @history = {}
    @arr = []
  end

  attr_accessor_with_history :my_attr, :a, :b, :c
end
