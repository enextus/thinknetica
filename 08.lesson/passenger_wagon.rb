
# frozen_string_literal: true

# class CargoWagon
class PassengerWagon < Wagon
  def initialize(capacity)
    super(capacity, 'passenger')
    @capacity = @capacity.to_i
    @free_places_amount = @capacity if @capacity.positive?
    @free_places_amount ||= 0
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
