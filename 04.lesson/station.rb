# frozen_string_literal: true

# class Station
class Station
  include InstanceCounter

  @@all_stations = []

  def self.all
    @@all_stations
  end

  attr_reader :name, :trains

  def initialize(name)
    @name = name
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
end
