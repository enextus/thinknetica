
# frozen_string_literal: true

# class CargoWagon
class PassengerWagon < Wagon
  def initialize(capacity)
    super(capacity, 'passenger')
    @free_places_amount = @capacity
  end

  def booking_single_place
    return if @free_places_amount.zero?
    @free_places_amount -= 1
  end

  def how_places_are_booked
    @capacity - @free_places_amount
  end

  def free_places_amount
    @capacity - how_places_are_booked
  end
end
