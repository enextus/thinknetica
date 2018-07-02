# frozen_string_literal: true

# class AppController
class AppController
  attr_reader :users

  def initialize
    @users = {}
  end

  def show_actions
    messages = ['Select the action by entering a number from the list: ',
                '  1 - Create user',
                BORDERLINE.to_s,
                'To exit the menu, type: exit',
                BORDERLINE.to_s]
    messages.each { |action| puts action }
  end

  def action(choice)
    case choice
    when '1'
      create_user
    else
      puts 'Re-enter!'
    end
    puts BORDERLINE
  end

  private

  # ###############    1 - creation of a user  #############################

  def create_user
    if @users.keys.any?
      user_exists
    else
      create_user!
    end
  end

  def user_exists
    puts "User '#{@users.values[0].name}' already exist. Only one user allowed!"
  end

  def message_create_user
    @message = 'Enter the user name in this format [a-z\d]+: '
  end

  # creating user
  def create_user!
    message_create_user
    user = nil

    loop do
      print @message
      name = gets.chomp

      user = User.new(name)

      @users[name.to_sym] = user
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
    puts "\nUser with the name: «#{name}» was successfully created!"
  end
end
