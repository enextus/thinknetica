# frozen_string_literal: true

# class Route
class Route
  attr_reader :stations, :name

  def initialize(start_station, stop_station)
    @stations = [start_station, stop_station]
    @name = start_station + " - " + stop_station
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
    @stations.each { |station| puts station.name }
  end

  def start_station
    @stations.first
  end

  def stop_station
    @stations.last
  end
end
