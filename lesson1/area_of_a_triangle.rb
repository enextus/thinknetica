# Программа определения площади треугольника по его сторонам.

puts 'Программа определения площади треугольника по его сторонам.'
print 'Пожалуйста введите длину основания (a) треугольника в сантиметрах: '
length_of_base_of_triangle = gets.to_f

print 'Пожалуйста введите высоту (h) треугольника в сантиметрах: '
height_of_the_triangle = gets.to_f

area_of_a_triangle = 0.5 * length_of_base_of_triangle * height_of_the_triangle

puts "Площадь треугольника составляет: #{area_of_a_triangle} см/2."
