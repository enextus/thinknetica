# frozen_string_literal: true

# class AppController
class AppController
  attr_reader :user, :diller

  def initialize
    @user = nil
    @diller = nil
    @cards = Cards.new
    @game_bank = GameBank.new
  end

  def show_actions
    messages = ['Select the action by entering a number from the list: ',
                '  1 - Create user & diller.',
                '  2 - Show user properties.',
                '  3 - Show diller properties.',
                '  4 - Show whole cards.',
                '  7 - Start new game.',
                BORDERLINE.to_s,
                'To exit the menu, type: exit',
                BORDERLINE.to_s]
    messages.each { |action| puts action }
  end

  def action(choice)
    case choice
    when '1'
      create_users
    when '2'
      show_user_properties
    when '3'
      show_diller_properties
    when '4'
      show_all_cards
    when '5'
      show_game
    when '7'
      start_game
    else
      puts 'Re-enter!'
    end
    puts BORDERLINE
  end

  private

  # #######################  1 - user create & diller  ########################

  def create_users
    if @user.nil?
      create_users!
    else
      user_exists
    end
  end

  def user_exists
    puts "User '#{@user.name}' already exist. Only one user allowed!"
  end

  def message_create_user
    @message = 'Enter the user name with format (latin [a-z\d]+): '
  end

  # creating user
  def create_users!
    message_create_user
    user = nil

    loop do
      print @message
      name = gets.chomp

      user = User.new(name)
      diller = Diller.new

      @user = user
      @diller = diller

      break
    end
  rescue StandardError => exception
    error_message(exception)
    retry
  else
    message_user_created(user.name)
  end

  def error_message(exception)
    puts exception.message
  end

  def message_user_created(name)
    puts "\nUser with the name: «#{name}» & «diller» were successfully created!"
  end
end

# ##################    2 - show user properties  #############################

def show_user_properties
  if @user.nil?
    user_void
  else
    show_user_properties!
  end
end

def user_void
  puts 'No user exist. Please create one first!'
end

def show_user_properties!
  puts "User name: #{@user.name}"
  puts "User bank amount: $ #{@user.bank}"
  puts "Game bank amount: $ #{@game_bank.amount}"
  puts 'User cards:'
  puts LINE
  @cards.puts_cards_symbols(@user.cards)
  puts "Score: #{@cards.score_weight}"
end

# ##################  3 - show diller properties  #############################

def show_diller_properties
  if @diller.nil?
    diller_void
  else
    show_diller_properties!
  end
end

def diller_void
  puts 'No diller exist. Please create one first!'
end

def show_diller_properties!
  puts "Diller name: #{@diller.name}"
  puts "Diller bank amount: $ #{@diller.bank}"
  puts "Game bank amount: $ #{@game_bank.amount}"
  puts 'Diller cards:'
  puts LINE
  @cards.puts_cards_symbols(@diller.cards)
  puts "Actual diller score: #{@cards.score_weight}"
end

# ###########################  4 -  cards  ####################################

def show_all_cards
  @cards.show_all_cards
end

# ##########################   5 - show game ##################################

def show_game
  # ...
end

# ##########################   7 - run game ###################################

def start_game
  if @user.nil?
    user_void
  else
    start_game!
  end
end

def start_game!
  user_getting_cards
  diller_getting_cards

  if @game_bank.check_amount?(@user.bank)
    @user.bank = @user.bank - @game_bank.pay
  else
    puts "no money"
    return
  end


  if @game_bank.check_amount?(@diller.bank)
    @diller.bank = @diller.bank - @game_bank.pay
  else
    puts "no money"
    return
  end

  @game_bank.amount += @game_bank.pay * 2

  puts "You have this cards:"
  @cards.score_calculate(@user.cards)
  puts "User bank = #{@user.bank}"
  puts "Dealer shows the         "

  puts LINE
  puts BORDERWAVE

  puts "Diller:"
  @cards.score_calculate(@diller.cards)
  puts "Diller bank = #{@diller.bank}"
  puts LINE
  puts BORDERWAVE
  puts "Game bank = #{@game_bank.amount}"
  puts BORDERWAVE
  puts LINE

  loop do
    puts "Would you like to (s)kip, (a)dd a card or (o)pen the cards?"
    answer = gets.downcase.strip
    case answer
    when 's'
      user_skip
      break
    when 'a'
      user_add_card
      break # if scoreHand(@playerHand) > 21
    when 'o'
      user_open_cards
      break
    end
  end

  puts "Would you like to play again? (y/n)"

  replay = gets.downcase.strip

  main if replay == 'y'
end

def user_add_card
  arr = @cards.getting_whole_deck
  card = arr[rand(arr.size)]
  @user.cards << card

  puts 'You drew the '
  puts @cards.puts_card_symbol(card)
  puts 'Your score is now '
  @cards.score_calculate(@user.cards)
  puts 'Bust! You lose.' if @cards.score_calculate(@user.cards) > 21
end

def user_getting_cards
  @user.cards = getting_cards
end

def diller_getting_cards
  @diller.cards = getting_cards
end

def getting_cards
  @cards.random_cards
end
