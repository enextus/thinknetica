# frozen_string_literal: true

# Program for determining the day number from the beginning of the year.
puts 'Program for determining the day number from the beginning of the year.'
print 'Please enter a day number: '
day = gets.to_i

print 'Please enter month: '
month = gets.to_i

print 'Please enter the year: '
year = gets.to_i

def whole_d(year, day, month)
  days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  # correction of the element value depending on the leap year
  days[1] = 29 if ((year % 4).zero? && year % 100 != 0) || (year % 400).zero?

  sum = 0
  days.each_with_index do |value, index|
    sum += value if index + 1 < month
  end
  puts sum + day
end

puts whole_d(year, day, month)
