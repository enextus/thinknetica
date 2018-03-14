# Программа определения типа треугольника по его двум катетам и гипотенузе.
# http://www.kurztutorial.info/mathematik/trigonometrie/en/dreieck.html

puts 'Программа определения типа треугольника по его сторонам.'
print 'Пожалуйста введите длину стороны катета (a) треугольника: '
side_a = gets.to_f

print 'Пожалуйста введите длину стороны катета (b) треугольника: '
side_b = gets.to_f

print 'Пожалуйста введите длину стороны гипотенузы (c) треугольника: '
side_c = gets.to_f

def rectangular(a, b, c)
  sides = [a, b, c].sort
  if (sides[2]**2 == (sides[0]**2 + sides[1]**2))
	 puts "Ваш треугольник является прямоугольным - It's a right-angled triangle"
    case sides.uniq.size
      when 1
        puts "Ваш треугольник является равносторонним - It's a equilateral triangle"
      when 2
        puts "Ваш треугольник является равнобедренным треугольником - It's a isosceles triangle"
      else
        puts "Ваш треугольник является неравносторонним треугольником - It's a scalene triangle"
    end
	else
	  puts "Ваш треугольник не является прямоугольным - It's a non-right-angled triangle"
	end
end

puts rectangular(side_a, side_b, side_c)
