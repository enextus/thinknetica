require 'pry'
# frozen_string_literal: true

# class Train
class Train
  include CompanyName
  include InstanceCounter
  include Validation

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  attr_reader :number, :type, :speed, :wagons, :route
  validate :name, :type, String
  validate :name, :presence
  validate :number, :format, /^[a-z\d]{3}-?[a-z\d]{2}$/i, 'XXX-XX or XXXXX'
  def initialize(number, type)
    @number = number
    @type = type
    validate!
    @speed = 0
    @wagons = []
    @@trains[number] = self
    register_instance
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
    @position = 0
    current_station.arrive(self)
  end

  def previous_station
    return if @position.zero?

    @route.stations[@position - 1]
  end

  def current_station
    @route.stations[@position]
  end

  def next_station
    return if @position >= @route.stations.size - 1

    @route.stations[@position + 1]
  end

  def move_train_forward
    return if @route.stations.nil? || @position >= @route.stations.size - 1

    current_station.depart(self)
    @position += 1
    current_station.arrive(self)
  end

  def move_train_backward
    return if @route.nil? || @position.zero?

    current_station.depart(self)
    @position -= 1
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

  def each_wagon(&block)
    if wagons.any?
      wagons.each { |wagon| block.call(wagon) }
    else
      any_wagons_void
    end
  end

  def any_wagons_void
    puts 'The wagons are not attached!'
  end
end
