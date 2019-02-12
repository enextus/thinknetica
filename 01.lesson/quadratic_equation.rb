# Программа вычисляет дискриминант (D) и корни уравнения
# (x1 и x2, если они есть) и выводит значения дискриминанта и корней на экран.

puts 'Программа вычисляет дискриминант (D) и корни уравнения.'
print 'Пожалуйста введите коэффициент (a): '
a = gets.to_f

print 'Пожалуйста введите коэффициент (b): '
b = gets.to_f

print 'Пожалуйста введите коэффициент (c): '
c = gets.to_f

# вычисляем дискриминант
d = b**2 - 4 * a * c

if d.positive?
  sqrt_of_d = Math.sqrt(d)
  x1 = -b + sqrt_of_d / 2 * a
  x2 = -b - sqrt_of_d / 2 * a
  puts "Дискриминанат = #{d},"
  puts "1-й корень = #{x1},"
  puts "2-й корень = #{x2}."
elsif d.zero?
  puts "Дискриминанат = #{d},"
  x = -b / 2 * a
  puts "Oба корня имееют одно значение = #{x}."
else
  puts 'Корней нет'
end
