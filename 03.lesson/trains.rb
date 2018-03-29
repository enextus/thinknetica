# frozen_string_literal: true

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

  def sub_train(train)
    trains.delete(train)
  end

  def all_trains
    trains
  end

  def type_trains(train)

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


# создаем экземпляры классов
# передаем параметры *(щлем сообщения)
# в методы экземпляров классов

# s = Station.new("Minsk")
# r = Route.new("Moskva", "Kiev")
# t = Train.new("Num001", "cargo", 10)

# class Station
# Имеет название, которое указывается при ее создании
# назжание передаем при создании экземпляра класса
# s = Station.new("Minsk")

# Может принимать поезда (по одному за раз)
# s.add_train(t)

# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# s.all_trains

# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# s.type_trains(type)

# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов
# sub_train(t)
