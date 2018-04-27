# frozen_string_literal: true

BORDERLINE = '_' * 50
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'app_controller.rb'

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

app_controller = AppController.new

puts "Добро пожаловать в программу 'Железная дорога'."

loop do
  app_controller.show_actions
  choice = gets.chomp.downcase
  break if choice == 'exit'
  app_controller.action(choice)
end
