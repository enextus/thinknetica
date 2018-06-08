# class Foo
class Foo
  def bar(key)
    h = { a: 1, b: 2 }
    value = h[key]
    value ||= 0
    # ...
  end

  def long_method
    sleep(1)
    puts "\e[H\e[2J"
    5.times do
      print "#{Time.now}"
      sleep(1)
      puts "\e[H\e[2J"
      Time.now
    end
  end

  def memorization
    @m ||= long_method
  end
end


class User
  attr_accessor :name

  def has_name?
    !!name
  end

  def has_not_name?
    !has_name?
  end

end
