# frozen_string_literal: true

# The program calculates the discriminant (D) and the roots of the equation.
# (x1 and x2, if any) and displays the values of the discriminant
# and the roots on the screen.

puts 'The program calculates the discriminant (D) and the roots of the equation.'
print 'Please enter a factor (a): '
a = gets.to_f

print 'Please enter a factor (b): '
b = gets.to_f

print 'Please enter a factor (c): '
c = gets.to_f
d = b**2 - 4 * a * c

if d.positive?
  sqrt_of_d = Math.sqrt(d)
  x1 = -b + sqrt_of_d / 2 * a
  x2 = -b - sqrt_of_d / 2 * a
  puts "discriminant = #{d},"
  puts "1st root = #{x1},"
  puts "2st root = #{x2}."
elsif d.zero?
  puts "discriminant = #{d},"
  x = -b / 2 * a
  puts "Both root have one value = #{x}."
else
  puts 'No roots'
end
