# frozen_string_literal: true

# s = Station.new("Minsk")
# r = Route.new("Moskva", "Kiev")
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
    trains << train
  end

  def all_trains
    trains
  end

  def return_type(train)
    trains.map.each do |item|
      item if item.train_type == train.train_type
    end
  end

  def sub_train(train)
    trains.delete(train)
  end
end

# Route
class Route
  attr_accessor :stations
  attr_reader :start_station, :stop_station

  def initialize(start_station, stop_station)
    @stations = [start_station, stop_station]
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def sub_station(station)
    stations.delete(station)
  end

  def all_stations
    stations
  end
end

# class Train
class Train
  attr_accessor :wagons, :speed
  attr_reader :train_num, :train_type

  def initialize(train_num, train_type, wagons, speed = 0)
    @train_num = train_num
    @train_type = train_type
    @wagons = wagons
    @speed = speed
  end

  def accelerate
    self.speed += 1
  end

  def current_speed
    speed
  end

  def stop
    self.speed = 0
  end

  def amount_wagons
    wagons
  end

  def add_wagons
    return false until speed.zero?
    self.wagons += 1
  end

  def sub_wagons
    return false until speed.zero?
    return false if wagons.zero?
    self.wagons -= 1
  end

  def receive_route(route)
    
  end
end
