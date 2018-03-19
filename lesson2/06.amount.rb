# Программа вычисления суммы покупок
# hash_main = {[:name], [:price price, :amount amount]}
h_purchases = {}
sum_purchases = 0

# получение значений и запись в хэш
loop do
  print 'Пожалуйста, введите название товара ("стоп" для окончания): '
  name = gets.chomp

  break if name == 'стоп'

  print 'Пожалуйста, введите цену за единицу товара: '
  price = gets.to_f

  print 'Пожалуйста, введите количество единиц: '
  amount = gets.to_i

  h_purchases[:"#{name}"] = [price: price, amount: amount]
end
puts '--------------------------------------------------------------------- '
puts 'Вывод хеша, имени товара, цены за единицу товара и кол-ва купл. товара: '
puts h_purchases

h_purchases.each do |name, value|
  print "Итоговая сумма за товар '#{name}' составляет: "
  value.each do |values|
    puts bill = (values[:price] * values[:amount]).round(2)
    sum_purchases += bill
  end
end

puts "Итоговая сумма #{sum_purchases.round(2)}"
