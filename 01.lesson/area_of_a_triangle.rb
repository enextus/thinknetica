# frozen_string_literal: true

# The program for determining the area of the triangle on its sides.

puts 'The program for determining the area of the triangle on its sides.'
puts 'Please enter the length of the base (a) of the triangle in centimeters: '
length = gets.to_f

print 'Please enter the height (h) of the triangle in centimeters: '
height = gets.to_f

area = 0.5 * length * height

puts "The area of ​​the triangle is: #{area} cm²."
