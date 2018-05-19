# frozen_string_literal: true

# class Route
class Route
  include InstanceCounter
  attr_reader :stations, :name

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    @name = "#{first_station.name}-#{last_station.name}"
    register_instance
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

  def first_station
    @stations.first
  end

  def last_station
    @stations.last
  end
end
