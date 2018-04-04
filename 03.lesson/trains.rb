# frozen_string_literal: true

# s = Station.new("Station")
# r = Route.new("Start", "Stop")
# t0 = Train.new("N01", "cargo", 20)
# t1 = Train.new("N02", "pass", 5)
# t2 = Train.new("N03", "cargo", 8)
# t3 = Train.new("N04", "pass", 7)

# Station
class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    return if trains.include?(train)
    @trains << train
  end

  def return_type(type)
    @trains.select { |train| train.type == type }
  end

  def depart(train)
    @trains.delete(train)
  end
end

# Route
class Route
  attr_reader :stations

  def initialize(start_station, stop_station)
    @stations = [start_station, stop_station]
  end

  def add_station(station)
    return if stations.include?(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    return if [@stations.first, @stations.last].include?(station)
    @stations.delete(station)
  end

  def all_stations
    p @stations
  end

  def start_station
    stations.first
  end

  def stop_station
    stations.last
  end
end

# class Train
class Train
  attr_reader :train_number, :type, :speed, :wagons, :route

  def initialize(train_number, type, wagons)
    @train_number = train_number
    @type = type
    @speed = 0
    @wagons = wagons
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
    route.stations[@index = 0]
  end

  def move_train_forward
    return if @route.stations.nil? || @index >= @route.stations.size - 1
    @index += 1
  end

  def move_train_backward
    return if @route.stations.nil? || @index.zero?
    @index -= 1
  end

  def next_station
    return if @index >= @route.stations.size - 1
    @index += 1
    route.stations[@index]
  end

  def previous_station
    return if @index.zero?
    @index -= 1
    @route.stations[@index]
  end

  def current_station
    @route.stations[@index]
  end
end
