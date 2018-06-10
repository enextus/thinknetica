# frozen_string_literal: true

# class Route
class Route
  include InstanceCounter
  include Validation
  attr_reader :stations, :name

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
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
    @stations.each(&:name)
  end

  def first_station
    @stations.first
  end

  def last_station
    @stations.last
  end

  protected

  def validate!
    raise 'Stations can not be less than two!' if @stations.size != 2
    @stations.each { |item| raise 'Only stations!' unless item.is_a? Station }
    raise 'Depart != arrive' if @stations[0].object_id == @stations[1].object_id
  end
end
