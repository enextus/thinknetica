# frozen_string_literal: true

# class PassengerTrain
class PassengerTrain < Train

  def initialize(train_number, wagons)
    super(train_number, wagons, 'passenger')
  end
end
