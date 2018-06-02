
# frozen_string_literal: true

# class CargoWagon
class PassengerWagon < Wagon
  def initialize(capacity)
    super(capacity, 'passenger')
    @free_capacity = @capacity
  end

  def booking_single_place
    return if @free_capacity.zero?
    @free_capacity -= 1
  end

  def loaded_capacity
    @capacity - @free_capacity
  end
end
