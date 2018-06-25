# frozen_string_literal: true

# module Accessors
module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym # @a
      var_history = "@#{name}_history".to_sym # @a_history
      puts "var_name =  @#{name}"
      puts "var_history =   @#{name}_history"

      # define both getter methods, for a var "@a" and each history "@a_history"
      define_method(name.to_sym) { instance_variable_get(var_name) } # t.a = nil,
      define_method("#{name}_history".to_sym) { instance_variable_get(var_history) } # t.a_history = nil,

      history = instance_variable_get("@#{name}_history") || []
      # setter for var_history
      instance_variable_set(var_history, history)
      puts "instance_variable_get(var_history) = #{instance_variable_get(var_history)}"

      # define setter method, for a var "@a" and set each history with history value in to "@a_history"
      define_method("#{name}=".to_sym) do |value|

        history << instance_variable_get(var_name)

        puts ""
        puts "var_name = #{var_name}"
        puts "value = #{value}"
        puts ""

        # setter for var
        instance_variable_set(var_name, value)

        puts ""
        puts "name = #{name}"
        puts "var_history = #{var_history}"
        puts "history = #{history}"
        puts ""

        # setter for var_history
        instance_variable_set(var_history, history)
        puts "instance_variable_get(var_history) = #{instance_variable_get(var_history)}"

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
