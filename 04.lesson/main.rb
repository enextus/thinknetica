# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'



# Программа позволяет пользователю через текстовый интерфейс делать следующее:
#
# - Создавать станции
# - Создавать поезда
# - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
# - Назначать маршрут поезду
# - Добавлять вагоны к поезду
# - Отцеплять вагоны от поезда
# - Перемещать поезд по маршруту вперед и назад
# - Просматривать список станций и список поездов на станции

loop do
  print 'Пожалуйста, введите название станции ("стоп" для окончания): '
  station = gets.chomp

  break if station == 'стоп'

  # dobavit w metod
  station = Station.new(station)

end

  puts "HERE"




  # frozen_string_literal: true

  # class RailRoad
  class RailRoad

    attr_reader :stations, :trains, :routes, :wagons

    def initialize
      @stations = []
      @trains = []
      @routes = []
      @wagons = []
    end

    def seed
      if @stations.empty?
        s0 = Station.new('Москва')
        @stations << s0

        s3 = Station.new('Смоленск')
        @stations << s3

        s5 = Station.new('Минск')
        @stations << s5

        s7 = Station.new('Гомелъ')
        @stations << s7

        s10 = Station.new('Киев')
        @stations << s10

        r = Route.new(s0, s10)
        @routes << r

        r.add_station(s3)
        r.add_station(s5)
        r.add_station(s7)

        c_t = CargoTrain.new('Номер 01', 10)
        c_t.receive_route(r)
        @trains << c_t

        p_t = PassengerTrain.new('Номер 02', 7)
        p_t.receive_route(r)
        @trains << p_t
      end
    end
  end
