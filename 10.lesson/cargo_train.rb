# frozen_string_literal: true

# class CargoTrain
class CargoTrain < Train
  validate :number, :presence
  validate :number, :type, String
  validate :number, :format, /^[a-z\d]{3}-?[a-z\d]{2}$/i, 'XXX-XX or XXXXX'

  def initialize(train_number)
    super(train_number, 'cargo')
  end

  def add_wagon(wagon)
    super if @type == wagon.type
  end
end
