
# frozen_string_literal: true

# class CargoWagon
class PassengerWagon < Wagon
  attr_reader :place_capacity

  def initialize(place_capacity)
    super('passenger')
    @place_capacity = place_capacity
    @free_places_amount = @place_capacity if @place_capacity.positive?
    @free_places_amount ||= 0
  end

  def booking_single_place
    return if @free_places_amount.zero?
    @free_places_amount -= 1
  end

  def how_places_are_booked
    @place_capacity - @free_places_amount
  end

  def free_places_amount
    @place_capacity - how_places_are_booked
  end
end
