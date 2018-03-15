# Программа ыаполения массива с шагом 5
array = (10..100).to_a.find_all{ |elem| elem % 5 == 0 }
puts "#{array}"
