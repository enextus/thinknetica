# frozen_string_literal: true

# The program of determining the type of triangle on its two legs and hypotenuse

puts 'Program of determining the type of triangle on its two legs & hypotenuse.'
print 'Please enter the length of the side of the leg (a) of the triangle: '
a = gets.to_f

print 'Please enter the length of the side of the leg (b) of the triangle: '
b = gets.to_f

print 'Enter the length of the side of the hypotenuse (c) of the triangle: '
c = gets.to_f

def checkvars(first_leg, second_leg, hypotenuse)
  arr = [first_leg, second_leg, hypotenuse].sort

  return if arr.include?(0) || arr.min.negative?

  arr
end

def rectangular(first_leg, second_leg, hypotenuse)
  array = checkvars(first_leg, second_leg, hypotenuse)

  return 'Impossible side length' if array.class != Array

  case (array[2]**2).equal?(array[0]**2 + array[1]**2)
  when true
    puts 'Your triangle is rectangular.'
  else
    puts 'Your triangle is not rectangular.'
  end
  case array.uniq.size
  when 1
    puts 'Your triangle is equilateral.'
  when 2
    puts 'Your triangle is an isosceles triangle.'
  end
end

puts rectangular(a, b, c)
