# frozen_string_literal: true

# class User
class User
  include Validation

  validate :name, :presence
  validate :name, :format, /^[a-z\d]+$/i, '^[a-z\d]+$...'

  @@all_users = []

  def self.all
    @@all_stations
  end

  attr_reader :name

  def initialize(name)
    @name = name
    validate!
    @@all_users << self
    register_instance
  end

  # methods

end
