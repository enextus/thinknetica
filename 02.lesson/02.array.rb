# Программа выполения массива с шагом 5
# arr = (10..100).to_a.find_all { |elem| (elem % 5).zero? }
arr = (10..100).step(5).to_a

# выводим наш массив в виде столбца
arr.each { |f| puts f }
