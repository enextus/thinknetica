
# frozen_string_literal: true

# class CargoWagon
class CargoWagon < Wagon
  def initialize(capacity)
    super(capacity, 'cargo')
    @free_capacity = @capacity
  end

  def load_volume(amount)
    return if amount > @free_capacity || @free_capacity.zero?
    @free_capacity -= amount
  end

  def loaded_capacity
    @capacity - @free_capacity
  end
end
