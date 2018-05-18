# frozen_string_literal: true

# class Train
class Train
  include CompanyName
  attr_reader :train_number, :type, :speed, :wagons, :route

  def initialize(train_number, type)
    @train_number = train_number
    @type = type
    @speed = 0
    @wagons = []
  end

  def current_wagons_number
    @wagons.size
  end

  def add_wagon(wagon)
    return unless speed.zero?
    @wagons << wagon
  end

  def delete_wagon
    return unless speed.zero? || wagons.zero?
    @wagons.pop
  end

  def assign_route(route)
    @route = route
    @index = 0
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

  def accelerate(value)
    return unless value.positive?
    @speed += value
  end

  def decelerate(value)
    return if value.negative? || @speed < value
    @speed -= value
  end
end
