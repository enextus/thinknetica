# Программа наполнения массива от 1 до 100 числами Фибоначчи
# M[n] = fib(n - 1) + fib(n - 2)
# Нам нужны не все предыдущие результаты, а только два последних.
# Можно начать с 0 и идти вверх до 100.

# создаем массив arr в 100 элементов
arr = (0..100).to_a

def fib(arr)
  a = 0
  b = 1

  arr.each do |index|
    a, b = b, a + b
    arr[index] = a
  end
end

# заполняем наш массив числами фибоначчи вызывая метод fib
fib(arr)

# выводим наш массив в виде столбца
arr.each { |f| puts f }

# выводим наш массив в виде строки
arr.each { |f| print f, ', ' }
