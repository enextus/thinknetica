# Программа наполнения массива от 1 до 100 числами Фибоначчи
# M[n] = fib(n - 1) + fib(n - 2)

arr = []

def fib(arr)
  a = 0
  b = 1

  i = 0
  loop do
    a, b = b, a + b
    break if a >= 100
    arr[i] = a
    i += 1
  end
end

fib(arr)

arr.each { |f| puts f }
