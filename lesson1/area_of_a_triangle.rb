# Программа определения площади треугольника по его сторонам.

puts 'Программа определения площади треугольника по его сторонам.'
print 'Пожалуйста введите длину основания (a) треугольника в сантиметрах: '
length = gets.to_f

print 'Пожалуйста введите высоту (h) треугольника в сантиметрах: '
height = gets.to_f

area = 0.5 * length * height

puts "Площадь треугольника составляет: #{area} см/2."
