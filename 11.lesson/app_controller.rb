# frozen_string_literal: true

# class AppController
class AppController
  attr_reader :user, :diller

  def initialize
    @user = nil
    @diller = nil
    @game_bank = nil
    @cards = Cards.new
  end

  def show_actions
    messages = ['Select the action by entering a number from the list: ',
                '  1 - Create user & diller.',
                '  2 - Show user properties.',
                '  3 - Show diller properties.',
                '  4 - Show whole cards.',
                '  5 - Start game.',
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
      message_user_exists
    end
  end

  def message_user_exists
    puts "User '#{@user.name}' already exist. Only one user allowed!"
  end

  def message_create_user
    @message = 'Enter the user name with format (latin [a-z\d]+): '
  end

  # creating user && diller
  def create_users!
    message_create_user
    user = nil
    diller = nil

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

  return if @user.cards.empty?
  puts 'User cards:'
  puts LINE
  @cards.puts_cards_symbols(@user.cards)
  puts "User score is now: #{@cards.score_calculate(@user.cards)}"
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

def show_diller_properties!(show = 0)
  puts "Diller name: #{@diller.name}"
  puts "Diller bank amount: $ #{@diller.bank}"

  return if @diller.cards.empty?
  puts 'Diller cards:'
  puts LINE
  case show
  when 1
    @cards.puts_cards_symbols(@diller.cards)
    puts "Diller score is now: #{@cards.score_calculate(@diller.cards)}"
  else
    puts '* *'
    puts 'Actual diller score: **'
  end
end

# ###########################  4 -  cards  ####################################

def show_all_cards
  @cards.show_all_cards
end

# ##########################   5 - run game ###################################

def start_game
  if @user.nil?
    user_void
  else
    first_init
    start_game!
  end
end

def first_init
  @game_bank = GameBank.new

  user_getting_cards
  diller_getting_cards

  make_a_user_bet
  make_a_diller_bet
  make_a_game_bank_pay
end

def start_game!
  puts CLEAR
puts "1. HERE"
  loop do
    show_a_game_bank_amount
    puts BORDERWAVE
    show_user_properties!
    puts BORDERWAVE
    show_diller_properties!(1)
    puts BORDERWAVE

    # return check_user_lost? || check_user_win?

    print 'Would you like to (s)kip, '
    print '(a)dd a card'  if @user.cards.size < 3
    puts ' or (o)pen the cards?'

    answer = gets.downcase.strip

    case answer
    when 's'
      diller_step
      break
    when 'a'
      user_add_card
      start_game!
      break
    when 'o'
      open_cards
      break
    end
  end
end

def diller_step
  if @cards.score_calculate(@diller.cards) >= 17
    start_game!
  elsif @cards.score_calculate(@diller.cards) < 17
    diller_add_card
    start_game!
  end
end

def open_cards
  diller_koeffizient = 21 - @cards.score_calculate(@diller.cards)
  user_koeffizient = 21 - @cards.score_calculate(@user.cards)

  if diller_koeffizient == user_koeffizient
    getting_prize
    puts "nobody has won!"
  elsif diller_koeffizient < user_koeffizient
    getting_prize(@diller)
    puts "#{@diller.name} has won!"
  elsif diller_koeffizient > user_koeffizient
    getting_prize(@user)
    puts "#{@user.name} has won!"
  end

  show_user_properties!
  show_diller_properties!(1)
end

def message_user_win
  puts 'User win!'
end

def message_diller_win
  puts 'Diller win!'
end

def getting_prize(player = nil)
  if player.nil?
    @win_prize = @game_bank.amount / 2
    @user.bank, @diller.bank = @win_prize, @win_prize

  else
    player.bank += @game_bank.amount
    @game_bank.amount = 0
  end
end

def ask_play_again
  message_play_again
  replay = gets.downcase.strip
  start_game! if replay == 'y'
end

def message_play_again
  puts 'Would you like to play again? (y/n)'
end

def user_add_card
  arr = @cards.getting_whole_deck
  card = arr[rand(arr.size)]
  @user.cards << card
  puts BORDERWAVE
  puts 'You drew the card: '
  puts LINE
  @cards.puts_card_symbol(card)
  puts LINE
  puts LINE
end

def diller_add_card
  arr = @cards.getting_whole_deck
  card = arr[rand(arr.size)]
  @diller.cards << card
  puts BORDERWAVE
  puts 'You drew the card: '
  puts LINE
  @cards.puts_card_symbol(card)
  puts LINE
  puts LINE
end

def check_user_win?
  @cards.score_calculate(@user.cards) == 21
end

def check_user_lost?
  @cards.score_calculate(@user.cards) > 21
end

def message_game_win
  puts 'YES! You win!'
end

def message_game_over
  puts 'Bust! You lose. Game over!'
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

def make_a_user_bet
  if @game_bank.check_amount?(@user.bank)
    @user.bank = @user.bank - @game_bank.pay
  else
    puts 'no money'
  end
end

def make_a_diller_bet
  if @game_bank.check_amount?(@diller.bank)
    @diller.bank = @diller.bank - @game_bank.pay
  else
    puts 'no money'
  end
end

def make_a_game_bank_pay
  @game_bank.amount += @game_bank.pay * 2
end

def show_a_game_bank_amount
  puts "Game bank amount: $ #{@game_bank.amount}"
end
