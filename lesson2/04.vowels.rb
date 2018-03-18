# Программа записи символьной переменной в хэш

# дан массив с буквами гласных звуков
vowels = ['а', 'е', 'ё', 'и', 'о', 'у', 'ы', 'э', 'ю', 'я']

hash = {}

vowels.each_with_index do |char, index|
  hash[char] = index + 1
end

puts hash
