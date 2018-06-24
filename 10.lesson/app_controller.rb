# frozen_string_literal: true

# class AppController
class AppController
  attr_reader :stations, :trains, :routes, :wagons

  def initialize
    @stations = {}
    @trains = {}
    @routes = {}
    @wagons = { 'cargo' => [], 'passenger' => [] }
  end

  def show_actions
    messages = ['Select the action by entering a number from the list: ',
                '  1 - Create station',
                '  2 - Create a passenger train',
                '  3 - Create a cargo train',
                '  4 - Create a passenger wagon',
                '  5 - Create a cargo wagon',
                '  6 - View the list of wagons created in the pool',
                '  7 - Attach to the train wagon from the pool',
                '  8 - Detach the wagon from the train to the pool',
                '  9 - Place the train at the station',
                ' 10 - View the list of stations',
                ' 11 - View the list of trains at the station',
                ' 12 - Create route',
                ' 13 - Add a station to the route',
                ' 14 - Delete station in route',
                ' 15 - Delete route',
                ' 16 - Assign the route by train',
                ' 17 - Move the train along the route forward',
                ' 18 - Move the train along the route back',
                ' 19 - View the list of created routes',
                ' 20 - See the list of wagons at the train',
                ' 21 - Display the list of trains at the station (&block)',
                ' 22 - Book a place in the passenger wagon',
                ' 23 - Load the volume in the cargo wagon',
                BORDERLINE.to_s,
                'To exit the menu, type: exit',
                BORDERLINE.to_s]
    messages.each { |action| puts action }
  end

  def action(choice)
    case choice
    when '1'
      create_station
    when '2'
      create_train('passenger')
    when '3'
      create_train('cargo')
    when '4'
      create_wagon('passenger')
    when '5'
      create_wagon('cargo')
    when '6'
      list_wagons
    when '7'
      attach_wagon
    when '8'
      detach_wagon
    when '9'
      link_to_station
    when '10'
      list_stations
    when '11'
      list_trains_on_station
    when '12'
      create_route
    when '13'
      add_station_in_to_route
    when '14'
      delete_station_in_route
    when '15'
      delete_route
    when '16'
      assign_route_to_train
    when '17'
      move_train_forward_by_route
    when '18'
      move_train_backward_by_route
    when '19'
      show_all_routes
    when '20'
      show_wagons_by_train
    when '21'
      show_trains_by_station
    when '22'
      load_passenger_wagon
    when '23'
      load_cargo_wagon
    else
      puts 'Re-enter!'
    end
    puts BORDERLINE
  end

  private

  # data input and menu build
  def getting(request, validator, success_callback)
    response = nil

    loop do
      args = []
      request.each do |message|
        print message
        args << gets.chomp
      end

      check = send(validator, *args)

      if check[:success]
        response = send(success_callback, *args)
        break
      else
        puts check[:errors]
      end
    end
    response
  end

  # ###############    0 - some methods #######################################

  def request_station
    ["Enter station name [#{@stations.keys.join(', ')}]: "]
  end

  # ###############    1 - creation of a station  #############################
  def message_create_station
    @message = 'Enter the station name: '
  end

  # creating station
  def create_station
    message_create_station
    station = nil
    loop do
      print @message
      name = gets.chomp

      station = Station.new(name)

      @stations[name.to_sym] = station
      break
    end
  rescue StandardError => exception
    error_message(exception)
    retry
  else
    message_station_created(station.name)
  end

  def message_station_created(name)
    puts "\nStation with the name: «#{name}» was successfully created!"
  end

  # ##################### 2 + 3 - creating train ##############################
  def message_create_train
    @message = 'Enter the train number with format > xxx(-?)xx: '
  end

  # creating train
  def create_train(type)
    message_create_train
    created_train = nil
    loop do
      print @message
      number = gets.chomp

      case type
      when 'passenger'
        train = PassengerTrain.new(number)
      when 'cargo'
        train = CargoTrain.new(number)
      end

      created_train = @trains[number.to_sym] = train
      break
    end
  rescue StandardError => exception
    error_message(exception)
    retry
  else
    message_train_created(created_train.number)
  end

  def error_message(exception)
    puts exception.message
  end

  def message_train_created(number)
    puts "\nTrain number [#{number}] was successfully created!"
  end

  # ###############    4 - 5 creating wagon #################################
  def message_create_wagon
    @message = 'Enter the number of seats or the volume of the wagon: '
  end

  # wagon creating
  def create_wagon(type)
    message_create_wagon
    loop do
      print @message
      capacity = gets.chomp

      case type
      when 'passenger'
        wagon = PassengerWagon.new(capacity)
        @wagons['passenger'] << wagon
      when 'cargo'
        wagon = CargoWagon.new(capacity)
        @wagons['cargo'] << wagon
      end

      break
    end
  rescue StandardError => exception
    error_message(exception)
    retry
  else
    message_wagon_created(type)
  end

  def message_wagon_created(type)
    puts "\nWagon of type: «#{type}» was created."
  end

  # ###############  6 - View the list of wagons in the pool ##################
  # wagon list
  def list_wagons
    if @wagons['cargo'].empty? && @wagons['passenger'].empty?
      wagons_void
    else
      wagons_list
    end
  end

  def wagons_void
    puts 'Create at least one wagon.'
  end

  def wagons_list
    puts "\nWagons: #{@wagons.map { |type, wagons| [type, wagons.count] }}"
  end

  # ######## 7  - Attach a wagon to the train from the pool of wagons #########
  # check the possibility of addition of the wagon to the train
  def attach_wagon
    if @trains.empty? || @wagons['passenger'].empty? && @wagons['cargo'].empty?
      trains_or_wagons_void
    elsif !check_train_wagons
      wagons_type_void
    else
      request = ["Enter train number [#{@trains.keys.join(', ')}]: "]
      getting(request, :approve_train_selection_for_wagons, :attach_wagon!)
      wagon_attached
    end
  end

  def trains_or_wagons_void
    puts 'There are no trains or wagons, first create them.'
  end

  def wagons_type_void
    puts 'Wagons of the right types are missing, create them.'
  end

  def wagon_attached
    puts "\nThe wagon is attached to the train."
  end

  # check the availability of awagon of the appropriate type to the train
  def check_train_wagons
    passenger_trains_amount = 0
    cargo_amount = 0
    @trains.each_value do |train|
      train.type == 'cargo' ? cargo_amount += 1 : passenger_trains_amount += 1
    end
    passenger_matches(passenger_trains_amount) || cargo_matches(cargo_amount)
  end

  def passenger_matches(passenger_trains_amount)
    return unless passenger_trains_amount.positive?
    @wagons['passenger'].size.positive?
  end

  def cargo_matches(cargo_amount)
    return unless cargo_amount.positive?
    @wagons['cargo'].size.positive?
  end

  # check the correctness of the number of the train
  def approve_train_selection_for_wagons(number)
    if check_wagons_for_train_type(number) && @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'No train or wagons of the required type!' }
    end
  end

  # checking the availability of wagons
  def check_wagons_for_train_type(number)
    @wagons[@trains[number.to_sym].type].any?
  end

  # add the wagon to the train
  def attach_wagon!(number)
    selected_train = select_train(number)
    wagon = @wagons[selected_train.type].last
    selected_train.add_wagon(wagon)
    @wagons[selected_train.type].delete(wagon)
  end

  # ###############   8 - detaching a wagon from a train  #####################
  # checking the possibility of detaching a wagon
  def detach_wagon
    if @trains.empty?
      trains_void
    else
      request = ["Enter train number [#{@trains.keys.join(', ')}]: "]
      getting(request, :approve_train_selection, :detach_wagon!)
      wagon_detached
    end
  end

  def trains_void
    puts 'There are no trains, create a train.'
  end

  def wagon_detached
    puts "\nThe wagon was successfully detach from the train."
  end

  # check the correctness of the number of the train
  def approve_train_selection(number)
    if @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'No such train number.' }
    end
  end

  # wagon detach
  def detach_wagon!(number)
    deleted_wagon = select_train(number).delete_wagon
    @wagons[select_train(number).type] << deleted_wagon
  end

  # ###############  9 - Placing the train at the station #####################
  # place the train to the station
  def link_to_station
    if @trains.empty? || @stations.empty?
      staions_or_trains_void
    else
      request = ["Enter train number [#{@trains.keys.join(', ')}]: "]
      train = getting(request, :approve_train_selection, :select_train)
      request = request_station
      station = getting(request, :approve_station_selection, :select_station)
      train_placed if station.arrive(train)
    end
  end

  def staions_or_trains_void
    puts 'Create at least one train and at least one station'
  end

  def train_placed
    puts "\nThe train was successfully placed at the station."
  end

  # check the selected station
  def approve_station_selection(name)
    if @stations[name.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'No station name or blank input, Re-enter!' }
    end
  end

  # choose a train
  def select_train(number)
    @trains[number.to_sym]
  end

  # choose the station
  def select_station(name)
    @stations[name.to_sym]
  end

  # ###############  10 - View the list of stations ###########################
  # list of available stations
  def list_stations
    if @stations.empty?
      stations_void
    else
      stations_list
    end
  end

  def stations_void
    puts 'Create at least one station.'
  end

  def stations_list
    puts "\nThere are the following stations: [#{@stations.keys.join(', ')}]"
  end

  # ###############  11 - View the list of trains at the station ##############
  # list of trains at the selected station
  def list_trains_on_station
    if @trains.empty? || @stations.empty?
      trains_or_stations_void
    else
      request = request_station
      station = getting(request, :approve_station_selection, :select_station)
      check_the_trains(station)
    end
  end

  def check_the_trains(station)
    if station.trains.any?
      trains_list_at_station(station.name)
      station.trains.each do |train|
        trains_type_wagons_info(train.number, train.type, train.wagons.size)
      end
    else
      at_station_trains_void(station.name)
    end
  end

  def trains_or_stations_void
    puts 'Create at least one train and at least one station, if not created.'
  end

  def trains_list_at_station(name)
    puts "\nThe selected station «#{name}» has trains:"
  end

  def trains_type_wagons_info(number, type, wagons)
    puts "Number «#{number}», type «#{type}», wagons #{wagons}."
  end

  def at_station_trains_void(name)
    puts "\nThere are no trains at #{name} station."
  end

  # ###############   12 - create_route   #####################################
  # create_route
  def create_route
    if @stations.empty? || @stations.size < 2
      stations_void_or_less
    else
      request = ["Enter of the depart station [#{@stations.keys.join(', ')}]: ",
                 "Enter the arrive station [#{@stations.keys.join(', ')}]: "]
      getting(request, :approve_stations_selection, :create_route!)
    end
  end

  def stations_void_or_less
    puts 'There are no stations or there are less than two. Create it.'
  end

  # check stations for the route
  def approve_stations_selection(depart, arrive)
    if @stations[depart.to_sym] && @stations[arrive.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'No station name nor blank input.' }
    end
  end

  # Create a route and record the created route in a hash of routes
  def create_route!(depart, arrive)
    route = Route.new(@stations[depart.to_sym], @stations[arrive.to_sym])
    @routes[route.name.to_sym] = route
    route_created(route.name)
  end

  def route_created(name)
    puts "Route «#{name}» was created."
  end

  # ############### 13 - Add a station to the route ###########################
  # Select a route and station to add
  def add_station_in_to_route
    if @routes.empty?
      routes_void
    else
      request = ["Enter route name [#{@routes.keys.join(', ')}]: "]
      route = getting(request, :approve_route_selection, :select_route)
      request = request_station
      station = getting(request, :approve_station_for_route, :select_station)
      station_added if route.add_station(station)
    end
  end

  def routes_void
    puts 'No routes, create route.'
  end

  def station_added
    puts 'The station was successfully added to the selected route.'
  end

  # checking the selected route
  def approve_route_selection(name)
    if @routes[name.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'There is no route or it is empty!' }
    end
  end

  # choose a route
  def select_route(name)
    @routes[name.to_sym]
  end

  # check selected station
  def approve_station_for_route(name)
    errors = []
    errors << 'There is no station with that name' unless @stations[name.to_sym]
    errors.empty? ? { success: true } : { success: false, 'errors': errors }
  end

  # ############### 14 - Delete station in route ###########################
  # select route and station to delete
  def delete_station_in_route
    if @routes.empty?
      routes_void
    else
      request = ["Enter route name [#{@routes.keys.join(', ')}]: "]
      route = getting(request, :approve_route_selection, :select_route)
      request = ["Enter station name [#{all_stations(route)}]: "]
      station = getting(request, :approve_station_for_route, :select_station)
      station_deleted if route.delete_station(station)
    end
  end

  def all_stations(route)
    # all_stations = route.stations.map { |station| station.name }.join(', ')
    route.stations.map(&:name).join(', ')
  end

  def station_deleted
    puts 'The station was successfully deleted from the selected route.'
  end

  # ############### 15 - Delete route ######################################
  def delete_route
    if @routes.empty?
      routes_void
    else
      request = ["Enter route name [#{@routes.keys.join(', ')}]: "]
      getting(request, :approve_route_selection, :delete_route!)
    end
  end

  # delete the route in the list of routes
  def delete_route!(name)
    route_added_to_list if @routes.delete(name.to_sym)
  end

  def route_added_to_list
    puts 'The route was successfully deleted from the list of routes.'
  end

  # ############### 16 - Assign a route for the train #########################
  def assign_route_to_train
    if @routes.empty? || @trains.empty?
      routes_or_trains_void
    else
      request = ["Enter route name [#{@routes.keys.join(', ')}]: "]
      route = getting(request, :approve_route_selection, :select_route)
      request = ["Enter train number [#{@trains.keys.join(', ')}]: "]
      train = getting(request, :approve_train_for_assign, :select_train)
      train.assign_route(route)
    end
  end

  # error message
  def routes_or_trains_void
    puts 'Routes or trains are missing, create!'
  end

  # check the number of the train
  def approve_train_for_assign(number)
    if @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'There is no train or input is empty!' }
    end
  end

  # ############### 17 - Move the train along the route forward ###############
  def move_train_forward_by_route
    if @routes.empty? || @trains.empty?
      routes_or_trains_void
    else
      request = ["Enter train number [#{@trains.keys.join(', ')}]: "]
      train = getting(request, :approve_train_for_assign, :select_train)
      train_moved_forward_by_route if train.move_train_forward
    end
  end

  def train_moved_forward_by_route
    puts 'The train is moved forward along the route.'
  end

  # ###############  18 - Move the train along the route back #################
  def move_train_backward_by_route
    if @routes.empty? || @trains.empty?
      routes_or_trains_void
    else
      request = ["Enter the train number [#{@trains.keys.join(', ')}]: "]
      train = getting(request, :approve_train_for_assign, :select_train)
      train_moved_backward if train.move_train_backward
    end
  end

  def train_moved_backward
    puts 'The train is moved back along the route.'
  end

  # ################### 19 - View the list of created routes ##################
  # list of available routes
  def show_all_routes
    if @routes.empty?
      routes_void
    else
      routes_list
    end
  end

  def routes_list
    puts "There are following routes: [#{@routes.keys.join(', ')}]"
  end

  # #################### 20 - show wagons by the train ########################
  # show wagons by the train
  def show_wagons_by_train
    if @trains.empty?
      trains_or_wagons_void
    else
      request = ["Enter the train number: [#{@trains.keys.join(', ')}]: "]
      getting(request, :approve_train_for_wagons_show, :show_wagon)
    end
  end

  # check the correctness of the number of the train
  def approve_train_for_wagons_show(number)
    if @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'There is no such this number. Re-enter!' }
    end
  end

  # show wagons list in the train
  def show_wagon(number)
    selected_train = select_train(number)
    selected_train.each_wagon do |wagon|
      puts "Capasity: #{wagon.capacity}"
      puts "Train type: #{wagon.type}"
      puts "Free capacity: #{wagon.free_capacity}"
    end
  end

  # #################### 21 - show trains by the station ######################
  # show trains by the station
  def show_trains_by_station
    if @stations.empty?
      stations_void
    else
      request = ["Enter station name: [#{@stations.keys.join(', ')}]: "]
      getting(request, :approve_station_selection, :show_train)
    end
  end

  # show trains at the station
  def show_train(name)
    selected_station = select_station(name)
    selected_station.each_train do |train|
      puts "Train number: #{train.number}"
      puts "Train type: #{train.type}"
      puts "Train speed: #{train.speed}"
      puts "Wagons list: #{train.wagons.size}"
    end
  end

  # #################### 22 - load_passenger_wagon ############################
  # load_passenger_wagon
  def load_passenger_wagon
    if @trains.empty? || check_availability_of_passenger_wagons
      trains_or_trains_with_wagons_void
    else
      request = ["Enter the train number: [#{passenger_trains_with_wagons}]: "]
      place_booked if getting(request, :approve_wagon, :booking_place!)
    end
  end

  # list of passenger trains with wagons
  def passenger_trains_with_wagons
    trains = Hash[@trains.map do |key, value|
      [key.to_sym, value] if value.wagons.any? && value.type == 'passenger'
    end
    ]
    trains.keys.join(', ')
  end

  # error message
  def trains_or_trains_with_wagons_void
    puts 'There are no trains or there are no wagons in them, please create!'
  end

  # check the presence of at least one train with at least one wagon
  def check_availability_of_passenger_wagons
    @trains.each do |train|
      train.each do |element|
        if element.class != Symbol
          return false if element.wagons.any? && element.type == 'passenger'
        end
      end
    end
  end

  # simplification - the place is always engaged in the first wagon
  def booking_place!(number)
    @trains[number.to_sym].wagons[0].booking_place_by_wagon
  end

  def place_booked
    puts 'One place in the first wagon was booked.'
  end

  # #################### 23 - load_cargo_wagon ################################
  # load_cargo_wagon
  def load_cargo_wagon
    if @trains.empty? || check_availability_of_cargo_wagons
      trains_or_trains_with_wagons_void
    else
      request = ["Enter the trains number: [#{cargo_trains_with_wagons}]: "]
      @select_cargo_train = getting(request, :approve_wagon, :select_train)
      request = ['Enter the amount to load into the wagon: ']
      volume_loaded if getting(request, :approve_volume, :loading_wagon_volume!)
    end
  end

  def approve_wagon(number)
    if @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'There are no trains with this number!' }
    end
  end

  def loading_wagon_volume!(amount)
    # simplification - the place is always engaged in the first wagon
    @select_cargo_train.wagons[0].loading_volume_by_wagon(amount.to_i)
  end

  # list of cargo trains with wagons
  def cargo_trains_with_wagons
    trains = Hash[@trains.map do |key, value|
      [key.to_sym, value] if value.wagons.any? && value.type == 'cargo'
    end
    ]
    trains.keys.join(', ')
  end

  # checking the correctness of the possible volume
  def approve_volume(amount)
    amount = amount.to_i
    errors = []
    errors << 'Impossible volume!' if amount.negative? || amount.zero?
    errors.empty? ? { success: true } : { success: false, 'errors': errors }
  end

  # checking the presence of at least one train with at least one wagon
  def check_availability_of_cargo_wagons
    @trains.each do |train|
      train.each do |element|
        if element.class != Symbol
          return false if element.wagons.any? && element.type == 'cargo'
        end
      end
    end
  end

  def volume_loaded
    puts 'The volume in the first train wagon was loaded.'
  end
end
