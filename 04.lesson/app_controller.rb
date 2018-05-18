# frozen_string_literal: true

# Программа позволяет управлять ж/д

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
    messages = ['Выберите желаемое действие, введя условный номер из списка: ',
                ' 1 - Создать станцию',
                ' 2 - Создать поезд',
                ' 3 - Создать вагон',
                ' 4 - Посмотреть список вагонов',
                ' 5 - Прицепить к поезду вагон из пула вагонов',
                ' 6 - Отцепить вагон от поезда в пул вагонов',
                ' 7 - Поместить поезд на станцию',
                ' 8 - Посмотреть список станций',
                ' 9 - Посмотреть список поездов на станции',
                ' 10 - Создать маршрут',
                ' 11 - Добавитъ станцию в маршрут',
                ' 12 - Удалитъ станцию в маршруте',
                ' 13 - Удалять маршрут',
                ' 14 - Назначать маршрут поезду',
                ' 15 - Переместить поезд по маршруту вперед',
                ' 16 - Переместить поезд по маршруту назад',
                ' 17 - Посмотреть список созданных маршрутов',
                BORDERLINE.to_s,
                'Для выхода из меню введите: exit',
                BORDERLINE.to_s]
    messages.each { |action| puts action }
  end

  def action(choice)
    case choice
    when '1'
      create_station
    when '2'
      create_train
    when '3'
      create_wagon
    when '4'
      list_wagons
    when '5'
      attach_wagon
    when '6'
      detach_wagon
    when '7'
      link_to_station
    when '8'
      list_stations
    when '9'
      list_trains_on_station
    when '10'
      create_route
    when '11'
      add_station_in_to_route
    when '12'
      delete_station_in_route
    when '13'
      delete_route
    when '14'
      assign_route_to_train
    when '15'
      move_train_forward_by_route
    when '16'
      move_train_backward_by_route
    when '17'
      show_all_routes
    else
      puts 'Повторите ввод!'
    end
    puts BORDERLINE
  end

  private

  # ввод текстовой информации и формирования меню
  def getting_info(request_info, validator, success_callback)
    response = nil

    loop do
      args = []
      request_info.each do |message|
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

  # ###############    0 - вспомогательные методы  ############################

  def request_info_station
    ["Ввод название станции [#{@stations.keys.join(', ')}]: "]
  end

  # ###############    1 - создание станции  ##################################

  # создание станции с валидацией ввода
  def create_station
    request_info = ['Ввод название станции: ']
    getting_info(request_info, :validate_station, :create_station!)
  end

  # проверка ввода названия станции
  def validate_station(name)
    errors = []
    errors << 'Название не может быть пустым. Повтор ввода!' if name.empty?
    errors << 'Станция с таким названием уже есть' if @stations[name.to_sym]
    errors.empty? ? { success: true } : { success: false, 'errors': errors }
  end

  # запись созданной станции в хеш станций @stations
  def create_station!(name)
    station = Station.new(name)
    @stations[name.to_sym] = station
    station_created(station.name)
  end

  def station_created(name)
    puts "\n Станция «#{name}» создана."
  end

  # ###############    2 - создание поезда  ###################################

  # создание поезда с валидацией ввода
  def create_train
    request_info = ['Укажите тип поезда (1 - пассажирский, 2 - грузовой): ',
                    'Ввод номер поезда: ']
    getting_info(request_info, :validate_train, :create_train!)
  end

  # проверка ввода названия и типа поезда
  def validate_train(type, train_number)
    errors = []
    valid_types = %w[1 2]
    errors << 'Номер поезда не может быть пуст!' if train_number.empty?
    errors << 'Неверный тип! Есть тип 1 и 2!' unless valid_types.include?(type)
    errors << 'Поезд с таким номером уже есть!' if @trains[train_number.to_sym]
    errors.empty? ? { success: true } : { success: false, 'errors': errors }
  end

  # записъ созданного поезда в хеш поездов
  def create_train!(type, train_number)
    case type
    when '1'
      train = PassengerTrain.new(train_number)
    when '2'
      train = CargoTrain.new(train_number)
    end
    @trains[train_number.to_sym] = train
    train_created(train.train_number)
  end

  def train_created(number)
    puts "\n Позд номер: «#{number}» создан."
  end

  # ###############    3 - создание вагона  ##################################

  # создание вагона с валидацией ввода
  def create_wagon
    request_info = ['Укажите тип вагона (1 - пассажирский, 2 - грузовой): ']
    getting_info(request_info, :validate_wagon, :create_wagon!)
  end

  # проверка ввода названия и типа вагона
  def validate_wagon(type)
    errors = []
    valid_types = %w[1 2]
    errors << 'Неверный тип! Есть тип 1 и 2!' unless valid_types.include?(type)
    errors.empty? ? { success: true } : { success: false, 'errors': errors }
  end

  # записъ созданного вагона
  def create_wagon!(type)
    case type
    when '1'
      wagon = PassengerWagon.new
      @wagons['passenger'] << wagon
    when '2'
      wagon = CargoWagon.new
      @wagons['cargo'] << wagon
    end
    wagon_created(wagon.type)
  end

  def wagon_created(type)
    puts "\n Вагон типа: «#{type}» создан."
  end

  # ###############  4 - Посмотреть список вагонов с типом ###################

  # список имеющихся вагонов
  def list_wagons
    if @wagons['cargo'].empty? && @wagons['passenger'].empty?
      wagons_void
    else
      wagons_list
    end
  end

  def wagons_void
    puts 'Создайте минимум один вагон'
  end

  def wagons_list
    puts "\n Вагоны: #{@wagons.map { |type, wagons| [type, wagons.count] }}"
  end

  # ###############    5 - добавление вагона к поезду #########################

  # проверка добавления вагона к поезду
  def attach_wagon
    if @trains.empty? || @wagons['passenger'].empty? && @wagons['cargo'].empty?
      trains_or_wagons_void
    elsif !check_trains_wagons
      wagons_type_void
    else
      request_info = ["Введите номер поезда: [#{@trains.keys.join(', ')}]: "]
      getting_info(request_info, :validate_train_selection_for_wagons, :attach_wagon!)
      wagon_attached
    end
  end

  def trains_or_wagons_void
    puts 'Поезда или/и вагоны отсутствуют, сначала создайте их.'
  end

  def wagons_type_void
    puts 'Вагоны нужных типов отсутствуют, создайте достаточное количество.'
  end

  def wagon_attached
    puts "\n Вагон прицеплен к поезду."
  end

  # проверка наличия минимума вагона соответсвующего типа к поезду
  def check_trains_wagons
    passenger_trains_amount = 0
    cargo_trains_amount = 0
    @trains.each_value do |train|
      case train.type
      when 'passenger'
        passenger_trains_amount += 1
      when 'cargo'
        cargo_trains_amount += 1
      end
    end
    passenger_wagongs_trains_matches(passenger_trains_amount) || cargo_wagongs_trains_matches(cargo_trains_amount)
  end

  def passenger_wagongs_trains_matches(passenger_trains_amount)
    return unless passenger_trains_amount.positive?
    @wagons['passenger'].size.positive?
  end

  def cargo_wagongs_trains_matches(cargo_trains_amount)
    return unless cargo_trains_amount.positive?
    @wagons['cargo'].size.positive?
  end

  # проверка правильности номера поезда
  def validate_train_selection_for_wagons(train_number)
    if check_wagons_for_train_type(train_number) && @trains[train_number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Нет поезда или вагонов нужного типа!' }
    end
  end

  # проверка наличия вагонов
  def check_wagons_for_train_type(train_number)
    @wagons[@trains[train_number.to_sym].type].any?
  end

  # добавляем вагон к поезду
  def attach_wagon!(train_number)
    selected_train = select_train(train_number)
    wagon = @wagons[selected_train.type].last
    selected_train.add_wagon(wagon)
    @wagons[selected_train.type].delete(wagon)
  end

  # ###############    6 - отцепка вагона от поезда ###########################

  # проверка возможности отцепить вагон
  def detach_wagon
    if @trains.empty?
      trains_void
    else
      request_info = ["Ввод номер поезда [#{@trains.keys.join(', ')}]: "]
      getting_info(request_info, :validate_train_selection, :detach_wagon!)
      wagon_detached
    end
  end

  def trains_void
    puts 'Поезда отсутствуют, создайте поезд.'
  end

  def wagon_detached
    puts "\n Вагон успешно отцеплен от поезда."
  end

  # проверка правильности номера поезда
  def validate_train_selection(train_number)
    if @trains[train_number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Поезда нет!' }
    end
  end

  # отцепка вагонa
  def detach_wagon!(train_number)
    deleted_wagon = select_train(train_number).delete_wagon
    @wagons[select_train(train_number).type] << deleted_wagon
  end

  # ###############  7 - Помещение поезда на станцию ##########################

  # помещаем поезд на станцию
  def link_to_station
    if @trains.empty? || @stations.empty?
      staions_or_trains_void
    else
      request_info = ["Ввод номер поезда [#{@trains.keys.join(', ')}]: "]
      train = getting_info(request_info, :validate_train_selection, :select_train)
      request_info = request_info_station
      station = getting_info(request_info, :validate_station_selection, :select_station)
      station.arrive(train)
      train_linked
    end
  end

  def staions_or_trains_void
    puts 'Создайте минимум один поезд и минимум одну станцию'
  end

  def train_linked
    puts "\n Поезд успешно помещен на станцию."
  end
  # метод validate_train_selection находиться в коде выше

  # проверка вьбранной станции
  def validate_station_selection(name)
    if @stations[name.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Станции нет или пустой ввод, повторите!' }
    end
  end

  # выбираем поезд
  def select_train(train_number)
    @trains[train_number.to_sym]
  end

  # выбираем станцию
  def select_station(name)
    @stations[name.to_sym]
  end

  # ###############  8 - Посмотреть список станций ############################

  # список имеющихся станций
  def list_stations
    if @stations.empty?
      stations_void
    else
      stations_list
    end
  end

  def stations_void
    puts 'Создайте минимум одну станцию'
  end

  def stations_list
    puts "\n Имеются следующее станции: [#{@stations.keys.join(', ')}]: "
  end

  # ###############  9 - Посмотреть список поездов на станции   ###############

  # список поездов на выбранной станции
  def list_trains_on_station
    if @trains.empty? || @stations.empty?
      trains_or_stations_void
    else
      request_info = request_info_station
      station = getting_info(request_info, :validate_station_selection, :select_station)
      if station.trains.any?
        trains_list_at_station(station.name)
        station.trains.each do |train|
          trains_type_wagons_info(train.train_number, train.type, train.wagons.size)
        end
      else
        at_station_trains_void(station.name)
      end
    end
  end

  def trains_or_stations_void
    puts 'Создайте минимум один поезд и минимум одну станцию, если несозданы'
  end

  def trains_list_at_station(name)
    puts "\n На выбранной вами станции «#{name}» имеются поезда:"
  end

  def trains_type_wagons_info(number, type, wagons)
    puts "«#{number}», «#{type}», «#{wagons}»"
  end

  def at_station_trains_void(name)
    puts "\n На выбранной станции «#{name}» поезда отсутствуют."
  end

  # ###############   10 - Создать маршрут   ###################################

  # создаем маршрут
  def create_route
    if @stations.empty? || @stations.size < 2
      stations_void_or_less_as_two
    else
      request_info = ["Ввод начальной станции [#{@stations.keys.join(', ')}]: ",
                      "Ввод конечной станции [#{@stations.keys.join(', ')}]: "]
      getting_info(request_info, :validate_stations_selection, :create_route!)
    end
  end

  def stations_void_or_less_as_two
    puts 'Станции отсутствуют или их меньше двух. Создайте мин. две станции.'
  end

  # проверка станций для маршрута
  def validate_stations_selection(first_station, last_station)
    if @stations[first_station.to_sym] && @stations[last_station.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Станции нет или пустой ввод, повторите!' }
    end
  end

  # создание маршрута и записъ созданного маршрута в хеш маршрутов
  def create_route!(first_station, last_station)
    route = Route.new(@stations[first_station.to_sym], @stations[last_station.to_sym])
    @routes[route.name.to_sym] = route
    route_created(route.name)
  end

  def route_created(name)
    puts "Маршрут «#{name}» создан."
  end

  # ############### 11 - Добавитъ станцию в маршрут ############################

  # выбор маршрута и станции для добавления
  def add_station_in_to_route
    if @routes.empty?
      routes_void
    else
      # вводим название маршрута
      request_info = ["Ввод название маршрута [#{@routes.keys.join(', ')}]: "]
      route = getting_info(request_info, :validate_route_selection, :select_route)
      # вводим название станции
      request_info = request_info_station
      station = getting_info(request_info, :validate_station_selection_for_route, :select_station)
      # добавляем станцию в маршрут!"
      route.add_station(station)
      station_added
    end
  end

  def routes_void
    puts 'Маршруты отсутствуют, создайте маршрут.'
  end

  def station_added
    puts 'Станция успешно добавлена к выбранному маршруту.'
  end

  # проверка выбранного маршрута
  def validate_route_selection(name)
    if @routes[name.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Маршрута нет или ввод пуст, повторите!' }
    end
  end

  # выбираем маршрут
  def select_route(name)
    @routes[name.to_sym]
  end

  # проверка вьбранной станции
  def validate_station_selection_for_route(name)
    errors = []
    errors << 'Станции с таким именем нет! Ввод.' unless @stations[name.to_sym]
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end

  # ############### 12 - Удалитъ станцию в маршруте ###########################

  # выбор маршрута и станции для удаления
  def delete_station_in_route
    if @routes.empty?
      routes_void
    else
      # вводим название маршрута
      request_info = ["Ввод название маршрута [#{@routes.keys.join(', ')}]: "]
      route = getting_info(request_info, :validate_route_selection, :select_route)

      # вводим название станции
      all_stations = route.stations.map { |station| station.name }.join(', ')
      request_info = ["Ввод название станции [#{all_stations}]: "]
      station = getting_info(request_info, :validate_station_selection_for_route, :select_station)

      # добавляем станцию в маршрут!"
      route.delete_station(station)
      station_added
    end
  end

  # ############### 13 - Удалить маршрут ######################################

  def delete_route
    if @routes.empty?
      routes_void
    else
      # вводим название маршрута
      request_info = ["Ввод название маршрута [#{@routes.keys.join(', ')}]: "]
      getting_info(request_info, :validate_route_selection, :delete_route!)
    end
  end

  # удаляем маршрут в списке маршрутов"
  def delete_route!(name)
    @routes.delete(name.to_sym)
    route_added_to_list
  end

  def route_added_to_list
    puts 'Маршрут успешно удалена в списке маршрутов.'
  end

  # ############### 14 - Назначать маршрут поезду  ############################
  def assign_route_to_train
    if @routes.empty? || @trains.empty?
      routes_or_trains_void
    else
      # вводим название маршрута
      request_info = ["Ввод название маршрута [#{@routes.keys.join(', ')}]: "]
      route = getting_info(request_info, :validate_route_selection, :select_route)

      request_info = ["Ввод названия поезда [#{@trains.keys.join(', ')}]: "]
      train = getting_info(request_info, :validate_train_for_assign, :select_train)

      # назначаем маршрут поезду
      train.assign_route(route)
    end
  end

  def routes_or_trains_void
    puts 'Маршруты или поезда отсутствуют, создайте!'
  end

  # проверка ввода названия поезда
  def validate_train_for_assign(train_number)
    if @trains[train_number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Поезда нет или ввод пуст, повторите!' }
    end
  end

  # ############### 15 - Переместить поезд по маршруту вперед   ###############
  def move_train_forward_by_route
    if @routes.empty? || @trains.empty?
      routes_or_trains_void
    else
      request_info = ["Ввод названия поезда [#{@trains.keys.join(', ')}]: "]
      train = getting_info(request_info, :validate_train_for_assign, :select_train)

      # назначаем маршрут поезду
      train.move_train_forward
      train_moved_forward_by_route
    end
  end

  def train_moved_forward_by_route
    puts 'Поезд перемещен вперед по маршруту.'
  end

  # ###############  16 - Переместить поезд по маршруту назад   ###############
  def move_train_backward_by_route
    if @routes.empty? || @trains.empty?
      routes_or_trains_void
    else
      request_info = ["Ввод названия поезда [#{@trains.keys.join(', ')}]: "]
      train = getting_info(request_info, :validate_train_for_assign, :select_train)

      # назначаем маршрут поезду
      train.move_train_backward
      train_moved_backward_by_route
    end
  end

  def train_moved_backward_by_route
    puts 'Поезд перемещен назад по маршруту.'
  end

  # ############### 17 - Посмотреть список созданных маршрутов ################

  # список имеющихся маршрутов
  def show_all_routes
    if @routes.empty?
      routes_void
    else
      routes_list
      @routes.each { |route| puts route.inspect }
    end
  end

  def routes_list
    puts "Имеются следующее маршруты: [#{@routes.keys.join(', ')}]: "
  end
end
