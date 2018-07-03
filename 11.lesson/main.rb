# frozen_string_literal: true

LINE = ''
CLEAR = `clear`.freeze
BORDERLINE = '_' * 70
BORDERWAVE = '~' * 38

require_relative 'accessors'
require_relative 'validation'
require_relative 'cards'
require_relative 'user'
require_relative 'diller'
require_relative 'app_controller'

app_controller = AppController.new

puts CLEAR
puts 'Here is the blackjack software.'
puts LINE

loop do
  app_controller.show_actions
  choice = gets.chomp.downcase
  break if choice == 'exit'
  puts CLEAR
  app_controller.action(choice)
end
