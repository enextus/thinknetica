# frozen_string_literal: true

# class AppController
class AppController
  attr_reader :user, :diller

  def initialize
    @user = nil
    @diller = nil
    @cards = Cards.new
  end

  def show_actions
    messages = ['Select the action by entering a number from the list: ',
                '  1 - Create user & diller.',
                '  2 - Show user properties.',
                '  3 - Show diller properties',
                '  4 - Show all cards',
                '  7 - Start game',
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
  puts 'User cards:'
  puts LINE
  @cards.puts_cards_symbols(@user.cards)
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
  puts 'Diller cards:'
  puts LINE
  @cards.puts_cards_symbols(@diller.cards)
end

# ###########################  4 -  cards  ####################################
def show_all_cards
  @cards.show_all_cards
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

  # calculate card score
  @cards.score_calculate(@user.cards)
  # ...
end

def user_getting_cards
  p getting_cards.class
  p getting_cards
  @user.cards = getting_cards
end

def diller_getting_cards
  @diller.cards = getting_cards
end

def getting_cards
  @cards.random_cards
end
