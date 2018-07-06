# frozen_string_literal: true

# class User
class GameBank
  attr_accessor :amount

  def initialize
    @amount = 0
    @pay = 10
  end

  def pay
    @amount + @pay
  end

  def check_amount?(value)
    return true unless value.zero? || (value - @pay).negative?
  end
end
