# frozen_string_literal: true

# class CargoWagon
class CargoWagon < Wagon
  validate :capacity, :presence
  validate :capacity, :type, Integer
  validate :capacity, :range

  def initialize(capacity)
    super(capacity, 'cargo')
  end

  def loading_volume_by_wagon(amount)
    return if amount > @free_capacity || @free_capacity.zero?
    @free_capacity -= amount
  end
end
