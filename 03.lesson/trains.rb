# frozen_string_literal: true

# Station
class Station
  attr_accessor :trains
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    trains << train
  end

  def sub_train(train)
    trains.delete_at trains.index train
  end

  def all_trains
    trains
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
    stations.delete_at stations.index station
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

  def stop
    self.speed = 0
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
end
