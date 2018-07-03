# frozen_string_literal: true

# class User
class User
  include Validation

  validate :name, :presence
  validate :name, :format, /^[a-z\d]+$/i, '^[a-z\d]+$...'

  attr_reader :name, :bank
  attr_accessor :cards

  def initialize(name)
    @name = name
    validate!
    @bank = 100
    @cards = []
  end

  # methods
end
