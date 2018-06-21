# Программа определения порядкового номера дня с начала года
puts 'Программа определения порядкового номера дня с начала года.'
print 'Пожалуйста введите число: '
day = gets.to_i

print 'Пожалуйста введите месяц: '
month = gets.to_i

print 'Пожалуйста введите год: '
year = gets.to_i

def whole_d(year, day, month)
  days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  # коррекция значения элемента в зависимости от високосности года
  days[1] = 29 if ((year % 4).zero? && year % 100 != 0) || (year % 400).zero?

  sum = 0
  days.each_with_index do |value, index|
    sum += value if index + 1 < month
  end
    puts sum + day
end

puts whole_d(year, day, month)
