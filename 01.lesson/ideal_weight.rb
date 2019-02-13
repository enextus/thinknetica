# frozen_string_literal: true

# The program to determine the ideal weight of a person according to his height.

puts 'The program to determine the ideal weight of a person according to his height.'
print 'Please enter your name: '
name = gets.chomp.capitalize

print 'Please enter your height in centimeters: '
tall = gets.to_i

weight = tall - 110

if weight.negative?
  puts 'Your weight is already optimal.'
else
  puts "#{name}, Your optimal weight is: #{weight} kg."
end
