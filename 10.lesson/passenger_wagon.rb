
# frozen_string_literal: true

# class CargoWagon
class PassengerWagon < Wagon
  validate :capacity, :presence
  validate :capacity, :type, Integer
  validate :capacity, :range

  def initialize(capacity)
    super(capacity, 'passenger')
  end

  def booking_place_by_wagon
    return if @free_capacity.zero?
    @free_capacity -= 1
  end
end
