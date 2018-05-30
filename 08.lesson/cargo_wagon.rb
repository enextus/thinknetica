
# frozen_string_literal: true

# class CargoWagon
class CargoWagon < Wagon
  def initialize(capacity)
    super(capacity, 'cargo')
    @capacity = @capacity.to_i
    @free_volume_amount = @capacity if @capacity.positive?
    @free_volume_amount ||= 0
  end

  def load_volume_amount(amount)
    return if amount > @free_volume_amount || @free_volume_amount.zero?
    @free_volume_amount -= amount
  end

  def how_much_volume_is_loaded
    @capacity - @free_volume_amount
  end

  def free_volume_amount
    @capacity - how_much_volume_is_loaded
  end
end
