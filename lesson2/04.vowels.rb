# Программа записи символьной переменной в хэш

vowels = 'аеёиоуыэюя'

v = vowels.split('')

h = {}

v.each_with_index do |char, index|
  h[index + 1] = char if vowels.include?(char)
end

puts h
