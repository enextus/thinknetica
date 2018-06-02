
# frozen_string_literal: true

# class CargoWagon
class PassengerWagon < Wagon
  def initialize(capacity)
    super(capacity, 'passenger')
  end

  def booking_single_place
    return if @free_capacity.zero?
    @free_capacity -= 1
  end
end
