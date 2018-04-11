
# frozen_string_literal: true

# class CargoTrain
class CargoTrain < Train

  def initialize(train_number, wagons)
    super(train_number, wagons, 'cargo')
  end
end
