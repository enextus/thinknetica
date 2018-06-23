# frozen_string_literal: true

# module Accessors
module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_history = "@#{name}_history".to_sym
      history = []

      define_method(name.to_sym) { instance_variable_get(var_name) }
      define_method("#{name}_history".to_sym) { instance_variable_get(var_history) }

      define_method("#{name}=".to_sym) do |value|
        history << instance_variable_get(var_name)

        instance_variable_set(var_name, value)
        instance_variable_set(var_history, history)
      end
    end
  end

  def strong_attr_accessor(name, type)
    var_name = "@#{name}".to_sym

    define_method(name.to_sym) { instance_variable_get(var_name) }

    define_method("#{name}=".to_sym) do |value|
      raise TypeError, 'Wrong type argument!' if value.class != type
      instance_variable_set(var_name, value)
    end
  end
end
