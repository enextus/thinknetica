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
  attr_reader :start_station, :stop_station, :stations

  def initialize(start_station, stop_station)
    @start_station = start_station
    @stop_station = stop_station
    @stations = [@start_station, @stop_station]
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
end

# class Train
class Train
  attr_reader :train_number, :type, :speed, :wagons, :route

  def initialize(train_number, type, wagons)
    @train_number = train_number
    @type = type
    @speed = 0
    @wagons = wagons
    @count
    @route
  end

  def accelerate(value)
    return unless value.positive?
    @speed += value
  end

  def decelerate(value)
    return if value.zero? || value.negative? || (@speed - value).negative?
    @speed -= value
  end

  def add_wagon
    return unless speed.zero?
    @wagons += 1
  end

  def delete_wagon
    return unless speed.zero? ||  wagons.zero?
    @wagons -= 1
  end

  def receive_route(route, station)
    @route = route
    @count = 0
    station.add_train(self)
  end

  def move_train_forward(route, station)
    return if station.nil? || @count >= route.stations.size - 1
    station.depart(self)
    @count += 1
    station.add_train(self)
  end

  def move_train_backward(station)
    return if station.nil? || @count.zero?
    station.depart(self)
    @count -= 1
    station.add_train(self)
  end



  def prewious_station(route)
    return if station.zero?
    @count -= 1
    route.stations[@count]
  end

  def witch_station_is_now(route)
    route.stations[@count]
  end

  def next_station(route)
    return if station >= route.stations.size - 1
    @count += 1
    route.stations[@count]
  end
end
