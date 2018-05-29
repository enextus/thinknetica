
# frozen_string_literal: true

# class CargoWagon
class CargoWagon < Wagon
  attr_reader :volume_capacity

  def initialize(volume_capacity)
    super('cargo')
    @volume_capacity = volume_capacity
    @free_volume_amount = @volume_capacity if @volume_capacity.positive?
    @free_volume_amount ||= 0
  end

  def charge_volume_amount(amount)
    return if amount > @free_volume_amount || @free_volume_amount.zero?
    @free_volume_amount -= amount
  end

  def how_much_volume_was_charged
    @volume_capacity - @free_volume_amount
  end

  def free_volume_amount
    @volume_capacity - how_much_volume_was_charged
  end
end
