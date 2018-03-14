# Программа определения типа треугольника по его двум катетам и гипотенузе.
# http://www.kurztutorial.info/mathematik/trigonometrie/en/dreieck.html
# https://en.wikipedia.org/wiki/Pythagorean_triple

puts 'Программа определения типа треугольника по его сторонам.'
print 'Пожалуйста введите длину стороны катета (a) треугольника: '
a = gets.to_i

print 'Пожалуйста введите длину стороны катета (b) треугольника: '
b = gets.to_i

print 'Пожалуйста введите длину стороны гипотенузы (c) треугольника: '
c = gets.to_i

def rectangular(a, b, c)

  arr = [a, b, c].sort

  puts arr

  puts "arr[2]**2 = #{arr[2]**2}"

  puts "arr[0]**2 + arr[1]**2 = #{arr[0]**2 + arr[1]**2}"



  unless arr.include?(0) || arr.min < 0
    if (arr[2]**2).equal?(arr[0]**2 + arr[1]**2)
      puts 'Ваш треугольник является прямоугольным'
      puts 'Ваш треугольник также является равнобедренным треугольником' if arr.uniq.size == 2
    else
      puts 'Ваш треугольник не является прямоугольным'
    end
  else
    puts 'Невозможная длина сторон'
  end
end

puts rectangular(a, b, c)
