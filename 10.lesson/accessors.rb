# frozen_string_literal: true

# module Accessors
module Accessors
  @@history = {}

  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      arr = []
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        define_singleton_method("#{name}_history".to_sym) { @@history[name.to_sym] }
        arr << value
        @@history[name.to_sym] = arr
      end
    end
  end

  def strong_attr_accessor(name, type)
    var_name = "@#{name}".to_sym
    define_method(name.to_sym) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      instance_variable_set(var_name, value) if value.class == type
      raise TypeError, 'Wrong type argument!' if value.class != type
    end
  end
end
