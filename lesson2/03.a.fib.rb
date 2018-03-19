# Программа наполнения массива от 1 до 100 числами Фибоначчи
# M[n] = fib(n - 1) + fib(n - 2)

arr = []

def fib(arr)
  a = 0
  b = 1
  
  i=1
  while i < 12
    a, b = b, a + b
    arr[i] = a
  i+=1
  end
end

fib(arr)

arr.each { |f| puts f }
