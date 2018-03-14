# Программа определения идеального веса человека по его росту.

puts 'Программа определения идеального веса человека по его росту.'
print 'Пожалуйста введите Ваше имя: '
user_input_name = gets.chomp
user_input_name.capitalize!

print 'Пожалуйста введите Ваш рост в сантиметрах: '
user_input_tall = gets.to_i

user_ideal_weight = user_input_tall - 110

if user_ideal_weight < 0
  puts 'Ваш вес уже оптимальный.'
else
  puts "#{user_input_name}, Ваш оптимальный вес составляет: #{user_ideal_weight} кг."
end
