# frozen_string_literal: true

# class Wagon
class Wagon
  include CompanyName

  attr_reader :type

  def initialize(type)
    @type = type
  end
end
