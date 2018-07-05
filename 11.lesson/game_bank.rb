# frozen_string_literal: true

# class User
class GameBank
  attr_accessor :ammount

  def initialize
    @ammount = 0
    @pay = 10
  end

  def pay
    @ammount + @pay
  end

  def check_ammount?(value)
    return true unless value.zero? || (value - @pay).negative?
  end
end
