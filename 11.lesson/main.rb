# frozen_string_literal: true

BORDERLINE = '_' * 50
require_relative 'accessors'
require_relative 'validation'
require_relative 'user'
require_relative 'app_controller'

app_controller = AppController.new

puts 'Here is the blackjack software.'

loop do
  app_controller.show_actions
  choice = gets.chomp.downcase
  break if choice == 'exit'
  app_controller.action(choice)
end
