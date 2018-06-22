# frozen_string_literal: true

# module Validation
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # module ClassMethods
  module ClassMethods
    attr_accessor :checks

    def validate(attr, kind, *params)
      @checks ||= {}
      @checks[attr] ||= []
      @checks[attr] << { kind: kind, params: params }
    end
  end

  # moduele InstanceMethods
  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def validate_type(name, value, params)
      raise "'#{name}'.class is not '#{params.first}'" if value.class != params.first
    end

    def validate_presence(name, value, params)
      raise "'#{name}' is nil or empty!" if value.nil? || value == ''
    end

    def validate_format(name, value, params)
      raise "'#{name}' have wrong format '#{params[1]}'" if value !~ params[0]
    end

    def validate!
      self.class.checks.each do |key, checks|
        value = instance_variable_get("@#{key}".to_sym)
        checks.each do |check|
          send("validate_#{check[:kind]}", key, value, check[:params])
        end
      end
      true
    end
  end
end
