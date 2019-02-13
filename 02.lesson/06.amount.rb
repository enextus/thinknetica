# frozen_string_literal: true

# The program calculates the amount of purchases
# hash_main = {[:name], [:price price, :amount amount]}
h_purchases = {}
sum_purchases = 0

loop do
  print 'Please enter the name of the product ("stop" to finish): '
  name = gets.chomp

  break if name == 'stop'

  print 'Please enter the price per item: '
  price = gets.to_f

  print 'Please enter the number of items: '
  amount = gets.to_i

  h_purchases[name.to_s] = { price: price, amount: amount }
end
puts '--------------------------------------------------------------------- '
puts 'The output of unit prices and the number of purchases. product:'
puts h_purchases
puts '--------------------------------------------------------------------- '

h_purchases.each do |name, value|
  print "The total amount for the goods '#{name}' is up: "
  puts bill = (value[:price] * value[:amount]).round(2)
  sum_purchases += bill
end

puts '--------------------------------------------------------------------- '
puts "Total amount #{sum_purchases.round(2)}"
puts '--------------------------------------------------------------------- '
