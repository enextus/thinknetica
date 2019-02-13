# frozen_string_literal: true

# A program to write a character variable to a hash
# # /[а-яА-ЯЁё]/ all letters of the Russian alphabet
# %w[а б в г д е ё ж з и й к л м н о п р с т у ф х ц ч ш щ ъ ы ь э ю я]

# there is an array of letters of the Russian alphabet

alphabet = ('а'..'я').to_a

# there is an array of letters of vowels
vowels = %w[а е ё и о у ы э ю я]

# declare hash
hash = {}

alphabet.each_with_index do |char, index|
  hash[char] = index + 1 if vowels.include?(char)
end

# output hash
puts hash.inspect
