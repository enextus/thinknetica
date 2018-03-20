# Программа наполнения массива от 1 до 100 числами Фибоначчи
# M[n] = fib(n - 1) + fib(n - 2)

  fibbonacci = [0, 1]
  next_element = 1

  while next_element < 100
    fibbonacci << next_element
    next_element = fibbonacci[-1] + fibbonacci[-2]
  end

  p fibbonacci
