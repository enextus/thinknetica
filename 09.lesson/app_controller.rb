# frozen_string_literal: true

# class AppController позволяет управлять ж/д
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
                '  1 - Создать станцию',
                '  2 - Создать пассажирский поезд',
                '  3 - Создать грузовой поезд',
                '  4 - Создать пассажирский вагон',
                '  5 - Создать грузовой вагон',
                '  6 - Посмотреть список созданных вагонов в пуле',
                '  7 - Прицепить к поезду вагон из пула вагонов',
                '  8 - Отцепить вагон от поезда в пул вагонов',
                '  9 - Поместить поезд на станцию',
                ' 10 - Посмотреть список станций',
                ' 11 - Посмотреть список поездов на станции',
                ' 12 - Создать маршрут',
                ' 13 - Добавитъ станцию в маршрут',
                ' 14 - Удалитъ станцию в маршруте',
                ' 15 - Удалить маршрут',
                ' 16 - Назначать маршрут поезду',
                ' 17 - Переместить поезд по маршруту вперед',
                ' 18 - Переместить поезд по маршруту назад',
                ' 19 - Посмотреть список созданных маршрутов',
                ' 20 - Выводить список вагонов у поезда',
                ' 21 - Выводить список поездов на станции (&block)',
                ' 22 - Занять место в пассажирском вагоне',
                ' 23 - Заполнить объем в грузовом вагоне',
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
      puts 'Повторите ввод!'
    end
    puts BORDERLINE
  end

  private

  # ввод данных и формирование меню программы
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
    puts "\nСтанция «#{name}» создана."
  end

  # ###############    2 + 3 - создание поезда  ################################
  def message_create_train
    @message = 'Ввeдите номер поезда в формате > xxx(-?)xx: '
  end

  # создание поезда
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
    puts "\nПоезд номер [#{number}] успешно создан!"
  end

  # ###############    4 - 5 создание вагона  ##################################
  def message_create_wagon
    @message = 'Ввeдите количество мест или объем вагона: '
  end

  # создание вагона
  def create_wagon(type)
    message_create_wagon
    loop do
      print @message
      capacity = gets.to_i

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
    puts "\nВагон типа: «#{type}» создан."
  end

  # ###############  6 - Посмотреть список вагонов в пуле ###################ю##
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
    puts "\nВагоны: #{@wagons.map { |type, wagons| [type, wagons.count] }}"
  end

  # ###############    7  - Прицепить к поезду вагон из пула вагонов ###########
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
    puts "\nВагон прицеплен к поезду."
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
  def validate_train_selection_for_wagons(number)
    if check_wagons_for_train_type(number) && @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Нет поезда или вагонов нужного типа!' }
    end
  end

  # проверка наличия вагонов
  def check_wagons_for_train_type(number)
    @wagons[@trains[number.to_sym].type].any?
  end

  # добавляем вагон к поезду
  def attach_wagon!(number)
    selected_train = select_train(number)
    wagon = @wagons[selected_train.type].last
    selected_train.add_wagon(wagon)
    @wagons[selected_train.type].delete(wagon)
  end

  # ###############   8 - отцепка вагона от поезда   ###########################
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
    puts "\nВагон успешно отцеплен от поезда."
  end

  # проверка правильности номера поезда
  def validate_train_selection(number)
    if @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Поезда нет!' }
    end
  end

  # отцепка вагонa
  def detach_wagon!(number)
    deleted_wagon = select_train(number).delete_wagon
    @wagons[select_train(number).type] << deleted_wagon
  end

  # ###############  9 - Помещение поезда на станцию ##########################
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
    puts "\nПоезд успешно помещен на станцию."
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
  def select_train(number)
    @trains[number.to_sym]
  end

  # выбираем станцию
  def select_station(name)
    @stations[name.to_sym]
  end

  # ###############  10 - Посмотреть список станций ############################
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
    puts "\nИмеются следующее станции: [#{@stations.keys.join(', ')}]"
  end

  # ###############  11 - Посмотреть список поездов на станции   ###############
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
          trains_type_wagons_info(train.number, train.type, train.wagons.size)
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
    puts "\nНа выбранной вами станции «#{name}» имеются поезда:"
  end

  def trains_type_wagons_info(number, type, wagons)
    puts "Номер «#{number}», тип «#{type}», в составе #{wagons} вагон(а)"
  end

  def at_station_trains_void(name)
    puts "\nНа выбранной станции «#{name}» поезда отсутствуют."
  end

  # ###############   12 - Создать маршрут   ###################################
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

  # ############### 13 - Добавитъ станцию в маршрут ############################
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

  # ############### 14 - Удалитъ станцию в маршруте ############################
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

  # ############### 15 - Удалить маршрут #######################################
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

  # ############### 16 - Назначать маршрут поезду  #ю###########################
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
  def validate_train_for_assign(number)
    if @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Поезда нет или ввод пуст, повторите!' }
    end
  end

  # ############### 17 - Переместить поезд по маршруту вперед   ################
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

  # ###############  18 - Переместить поезд по маршруту назад ##################
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

  # ############### 19 - Посмотреть список созданных маршрутов #################
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

  # #################### 20 - show wagons by the train #########################
  # show wagons by the train
  def show_wagons_by_train
    if @trains.empty?
      trains_or_wagons_void
    else
      request_info = ["Введите номер поезда: [#{@trains.keys.join(', ')}]: "]
      getting_info(request_info, :validate_train_for_wagons_show, :show_wagon)
    end
  end

  # проверка правильности номера поезда
  def validate_train_for_wagons_show(number)
    if @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Нет такого номера поезда. Повторите ввод!' }
    end
  end

  # показать вагоны в поезде
  def show_wagon(number)
    selected_train = select_train(number)
    selected_train.each_wagon do |wagon|
      puts ''
      puts "Вместимость: #{wagon.capacity}"
      puts "Тип вагона: #{wagon.type}"
      puts "Free capacity: #{wagon.free_capacity}"
      puts BORDERLINE.to_s
    end
  end

  # #################### 21 - show trains by the station #######################
  # show trains by the station
  def show_trains_by_station
    if @stations.empty?
      stations_void
    else
      request_info = ["Введите имя станции: [#{@stations.keys.join(', ')}]: "]
      getting_info(request_info, :validate_station_selection, :show_train)
    end
  end

  # показать поезда на станции
  def show_train(name)
    selected_station = select_station(name)
    selected_station.each_train do |train|
      puts ''
      puts "Номер поезда: #{train.number}"
      puts "Тип поезда: #{train.type}"
      puts "Скорость поезда: #{train.speed}"
      puts "Кол-во прицепленных вагонов: #{train.wagons.size}"
      puts BORDERLINE.to_s
    end
  end

  # #################### 22 - load_passenger_wagon #############################
  # load_passenger_wagon
  def load_passenger_wagon
    if @trains.empty? || check_availability_of_passenger_wagons
      trains_or_trains_with_wagons_void
    else
      request_info = ["Введите номер поезда имеющего вагоны: [#{passenger_trains_with_wagons}]: "]
      getting_info(request_info, :validate_train_for_wagon_load, :book_place_by_train!)
      place_booked_by_train
    end
  end

  # список пассажирских поездов имеющих вагоны
  def passenger_trains_with_wagons
    converted = Hash[@trains.map { |key, value| [key.to_sym, value] if value.wagons.any? && value.type == 'passenger'  }]
    converted.keys.join(', ')
  end

  # сообщение об ошибке
  def trains_or_trains_with_wagons_void
    puts 'Поезда отсутствуют или в них нет вагонов, создайте!'
  end

  # проверка наличия минимум одного поезда с минимум одним вагоном
  def check_availability_of_passenger_wagons
    @trains.each do |train|
      train.each do |element|
        if element.class != Symbol
          return false if element.wagons.any? && element.type == 'passenger'
        end
      end
    end
  end

  def book_place_by_train!(number)
    # упрощение - место занимается всегда в первом вагоме поезда
    @trains[number.to_sym].wagons[0].booking_place_by_wagon
  end

  def place_booked_by_train
    puts 'Место в первом вагоне поезда занято.'
  end

  # #################### 23 - load_cargo_wagon #################################
  # load_cargo_wagon
  def load_cargo_wagon
    if @trains.empty? || check_availability_of_cargo_wagons
      trains_or_trains_with_wagons_void
    else
      request_info = ["Введите номер поезда имеющего вагоны: [#{cargo_trains_with_wagons}]: "]
      @selected_cargo_train = getting_info(request_info, :validate_train_for_wagon_load, :select_train)

      request_info = ["Введите обьем для загрузки в вагон: "]
      getting_info(request_info, :validate_volume_for_wagon_load, :loading_volume_by_wagons!)
      volume_loaded_by_train
    end
  end

  def validate_train_for_wagon_load(number)
    if @trains[number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Поезда с таким номером нет!' }
    end
  end

  def loading_volume_by_wagons!(amount)
    # упрощение - место занимается всегда в первом вагоме поезда
    @selected_cargo_train.wagons[0].loading_volume_by_wagon(amount.to_i)
  end

  # список грузовых поездов имеющих вагоны
  def cargo_trains_with_wagons
    converted = Hash[@trains.map { |key, value| [key.to_sym, value] if value.wagons.any? && value.type == 'cargo' }]
    converted.keys.join(', ')
  end

  # проверка правильности возможно обьема
  def validate_volume_for_wagon_load(amount)
    amount = amount.to_i
    errors = []
    errors << 'Невозможный обьем!' if amount.negative? || amount.zero?
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end

  # проверка наличия минимум одного поезда с минимум одним вагоном
  def check_availability_of_cargo_wagons
    @trains.each do |train|
      train.each do |element|
        if element.class != Symbol
          return false if element.wagons.any? && element.type == 'cargo'
        end
      end
    end
  end

  def volume_loaded_by_train
    puts 'Объем в первом вагоне поезда загружен.'
  end
end
