# frozen_string_literal: true

# class Station
class Station
  include InstanceCounter
  include Validation

  @@all_stations = []

  def self.all
    @@all_stations
  end

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@all_stations << self
    register_instance
  end

  def return_type(type)
    @trains.select { |train| train.type == type }
  end

  def arrive(train)
    return if trains.include?(train)
    @trains << train
  end

  def depart(train)
    @trains.delete(train)
  end

  def each_train(&block)
    trains.each { |train| block.call(train) }
  end

  protected

  def validate!
    raise 'Название не может быть пустым' if @name.nil? || @name.empty?
  end
end
