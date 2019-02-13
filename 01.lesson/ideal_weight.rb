# frozen_string_literal: true

# The program to determine the ideal weight of a person according to his height.

puts 'Программа определения идеального веса человека по его росту.'
print 'Пожалуйста введите Ваше имя: '
name = gets.chomp.capitalize

print 'Пожалуйста введите Ваш рост в сантиметрах: '
tall = gets.to_i

weight = tall - 110

if weight.negative?
  puts 'Ваш вес уже оптимальный.'
else
  puts "#{name}, Ваш оптимальный вес составляет: #{weight} кг."
end
