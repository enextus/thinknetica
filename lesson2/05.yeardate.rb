# Программа определения порядкового номера дня с начала года
puts 'Программа определения порядкового номера дня с начала года.'
print 'Пожалуйста введите число: '
day = gets.to_i

print 'Пожалуйста введите месяц: '
month = gets.to_i

print 'Пожалуйста введите год: '
year = gets.to_i

def leapyear(year)
  if (year % 4.zero? && year % 100 != 0) || (year % 400.zero?)
    @arr = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  else
    @arr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  end
end

def whole_d(year, day, month)
  year = year
  x = 0
  result = 0
  leapyear(year)
  @arr.inject(0) do |sum, i|
    x += 1
    result = sum + i if x < month
  end
  puts "Количество дней = #{result + day}"
end

whole_d(year, day, month)
