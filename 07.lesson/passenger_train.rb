# frozen_string_literal: true

# class PassengerTrain
class PassengerTrain < Train  
  def initialize(train_number)
    super(train_number, 'passenger')
  end

  def add_wagon(wagon)
    super if @type == wagon.type
  end
end
