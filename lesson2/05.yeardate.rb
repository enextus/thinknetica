# Программа определения порядкового номера дня с начала года
puts 'Программа определения порядкового номера дня с начала года.'
print 'Пожалуйста введите число: '
day = gets.to_i

print 'Пожалуйста введите месяц: '
month = gets.to_i

print 'Пожалуйста введите год: '
year = gets.to_i

def whole_d(year, day, month)
  arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  # коррекция значения элемента в зависимости от високосности года
  arr[1] = 29 if ((year % 4).zero? && year % 100 != 0) || (year % 400).zero?

  i = 0
  result = 0

  arr.inject(0) do |sum, index|
    i += 1
    puts "sum = #{sum} index = #{index}"
    result = sum + index if i < month
  end
  puts "Количество дней = #{result + day}"
end

whole_d(year, day, month)
