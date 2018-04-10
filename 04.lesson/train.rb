# frozen_string_literal: true

# class Train
class Train

  attr_reader :train_number, :wagons, :type, :speed, :route

  def initialize(train_number, wagons, type)
    @train_number = train_number
    @wagons = wagons
    @type = type
    @speed = 0
  end

  def accelerate(value)
    return unless value.positive?
    @speed += value
  end

  def decelerate(value)
    return if value.negative? || @speed < value
    @speed -= value
  end

  def add_wagon
    return unless speed.zero?
    @wagons += 1
  end

  def delete_wagon
    return unless speed.zero? || wagons.zero?
    @wagons -= 1
  end

  def receive_route(route)
    @route = route
    @index = 0
    current_station.arrive(self)
  end

  def move_train_forward
    return if @route.stations.nil? || @index >= @route.stations.size - 1
    current_station.depart(self)
    @index += 1
    current_station.arrive(self)
  end

  def move_train_backward
    return if @route.stations.nil? || @index.zero?
    current_station.depart(self)
    @index -= 1
    current_station.arrive(self)
  end

  def previous_station
    return if @index.zero?
    @route.stations[@index - 1]
  end

  def current_station
    @route.stations[@index]
  end

  def next_station
    return if @index >= @route.stations.size - 1
    @route.stations[@index + 1]
  end
end

# class PassengerTrain
class PassengerTrain < Train

  def initialize(train_number, wagons)
    # вызываешь супер, передаешь аргументы, инициализируешь в родителе
    super(train_number, wagons, 'passenger')
  end


end

# class CargoTrain
class CargoTrain < Train

  def initialize(train_number, wagons)
    # вызываешь супер, передаешь аргументы, инициализируешь в родителе
    super(train_number, wagons, 'cargo')
  end
end
