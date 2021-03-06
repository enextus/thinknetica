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

  def each_wagon(&block)
    if wagons.any?
      wagons.each { |wagon| block.call(wagon) }
    else
      any_wagons_void
    end
  end

  def any_wagons_void
    puts 'К поезду вагоны не прицеплены!'
  end

  protected

  def validate!
    # type = %w[passenger cargo]
    # raise 'Несуществующий тип поезда' unless type.include? @type
    raise 'Номер не может быть пустым, повторите ввод!' if @number.nil? || @number.empty?
    raise 'Неверный формат номера, повторите ввод!' if @number !~ /^[a-z\d]{3}-?[a-z\d]{2}$/i
  end
end
