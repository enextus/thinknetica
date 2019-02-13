# frozen_string_literal: true

# The program of determining the type of triangle on its two legs and hypotenuse

puts 'The program of determining the type of triangle on its two legs and hypotenuse.'
print 'Please enter the length of the side of the leg (a) of the triangle: '
a = gets.to_f

print 'Please enter the length of the side of the leg (b) of the triangle: '
b = gets.to_f

print 'Please enter the length of the side of the hypotenuse (c) of the triangle: '
c = gets.to_f

def rectangular(a, b, c)
  arr = [a, b, c].sort

  return 'Impossible side length' if arr.include?(0) || arr.min.negative?

  case (arr[2]**2).equal?(arr[0]**2 + arr[1]**2)
  when true
    puts 'Your triangle is rectangular.'
  else
    puts 'Your triangle is not rectangular.'
  end

  case arr.uniq.size
  when 1
    puts 'Your triangle is equilateral.'
  when 2
    puts 'Your triangle is an isosceles triangle.'
  end
end

puts rectangular(a, b, c)
