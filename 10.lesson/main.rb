# frozen_string_literal: true

BORDERLINE = '_' * 50
require_relative 'accessors'
require_relative 'validation'
require_relative 'instance_counter'
require_relative 'company_name'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'app_controller'

app_controller = AppController.new

puts 'Here is the railways software.'

loop do
  app_controller.show_actions
  choice = gets.chomp.downcase
  break if choice == 'exit'

  app_controller.action(choice)

  binding.pry
end
