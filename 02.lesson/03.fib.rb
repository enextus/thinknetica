# frozen_string_literal: true

# The program of filling the array from 1 to 100 Fibonacci numbers
# M[n] = fib(n - 1) + fib(n - 2)

fibbonacci = [0, 1]
next_element = 1

while next_element < 1000
  fibbonacci << next_element
  next_element = fibbonacci[-1] + fibbonacci[-2]
end

p fibbonacci
