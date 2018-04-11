# frozen_string_literal: true

# class CargoTrain
class CargoTrain < Train

  def initialize(train_number)
    super(train_number, 'cargo')
  end
end
