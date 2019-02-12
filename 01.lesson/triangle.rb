# Программа определения типа треугольника по его двум катетам и гипотенузе.
# https://en.wikipedia.org/wiki/Pythagorean_triple

puts 'Программа определения типа треугольника по его 3-м сторонам.'
print 'Пожалуйста введите длину стороны катета (a) треугольника: '
a = gets.to_f

print 'Пожалуйста введите длину стороны катета (b) треугольника: '
b = gets.to_f

print 'Пожалуйста введите длину стороны гипотенузы (c) треугольника: '
c = gets.to_f

def rectangular(a, b, c)
  arr = [a, b, c].sort

  return 'Невозможная длина сторон' if arr.include?(0) || arr.min.negative?

  case (arr[2]**2).equal?(arr[0]**2 + arr[1]**2)
  when true
    puts 'Ваш треугольник является прямоугольным.'
  else
    puts 'Ваш треугольник не является прямоугольным.'
  end

  case arr.uniq.size
  when 1
    puts 'Ваш треугольник является равносторонним.'
  when 2
    puts 'Ваш треугольник является равнобедренным треугольником.'
  end
end

puts rectangular(a, b, c)
