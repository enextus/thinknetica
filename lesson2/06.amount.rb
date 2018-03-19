# Программа вычисления суммы покупок
# hash_main = {[:name], [:price price, :amount amount]}
hash_names = {}
sum = 0
loop do
  print 'Пожалуйста, введите название товара ("стоп" для окончания): '
  name = gets.chomp

  break if name == 'стоп'

  print 'Пожалуйста, введите цену за единицу товара: '
  price = gets.to_f

  print 'Пожалуйста, введите количество единиц: '
  amount = gets.to_i
  hash_names[:"#{name}"] = [price: price, amount: amount]
end
puts '--------------------------------------------------------------------- '
puts 'Вывод хеша, имени товара, цены за единицу товара и кол-ва купл. товара: '
puts hash_names
hash_names.each_with_index do |(name, value), index|
  print "Итоговая сумма за товар '#{name}' составляет: "
  value.each do |couple|
    puts bill = (couple[:price] * couple[:amount]).round(2)
    sum += bill
  end
  puts "Итоговая сумма #{sum.round(2)}" if (index + 1).equal? hash_names.length
end
