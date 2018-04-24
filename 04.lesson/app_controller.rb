# frozen_string_literal: true

# Программа позволяет пользователю через текстовый интерфейс делать следующее:

# class AppController
class AppController
  attr_reader :stations, :trains, :routes, :wagons

  def initialize
    @stations = {}
    @trains = {}
    @routes = {}
  end

  def show_actions
    puts 'Выберите желаемое действие, введя условный номер из списка: '
    puts ' 1 - Создать станцию'
    puts ' 2 - Создать поезд'
    puts ' 3 - Прицепить к поезду вагон'
    puts ' 4 - Отцепить вагон от поезда'
    puts ' 5 - Поместить поезд на станцию'
    puts ' 6 - Посмотреть список станций'
    puts ' 7 - Посмотреть список поездов на станции'
    puts ' 8 - Создать маршрут'
    puts ' 9 - Добавитъ станцию в маршрут'
    puts ' 10 - Удалитъ станцию в маршруте'
    puts ' 11 - Добавлять маршрут'
    puts ' 12 - Удалять маршрут'
    puts ' 13 - Назначать маршрут поезду'
    puts ' 14 - Переместить поезд по маршруту вперед'
    puts ' 15 - Переместить поезд по маршруту назад'
    puts ' 16 - Посмотреть список созданных маршрутов'
    puts BORDERLINE
    puts 'Для выхода из меню введите: exit'
    puts BORDERLINE
  end

  def action(choice)
    case choice
    when '1'
      create_station
    when '2'
      create_train
    when '3'
      attach_wagon
    when '4'
      detach_wagon
    when '5'
      link_to_station
    when '6'
      list_stations
    when '7'
      list_trains_on_station
    when '8'
      create_route
    when '9'
      add_station_in_to_route
      ##################################################
    when '10'
      delete_station_in_to_route
    when '11'
      add_route
    when '12'
      delete_route
    when '13'
      receive_route_to_train
    when '14'
      move_train_forward_by_route
    when '15'
      move_train_backward_by_route
    when '16'
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

#  ###############   ОБРАЗЕЦ на ввод несколъкий параметров ############
=begin
# создание станции с валидацией ввода
  def _create_station
    request_info = ['Ввод название станции: ', 'цвет станции: ', 'и другие ']
    getting_info(request_info, :validate_station, :create_station!)
  end

# проверка ввода названия станции
  def _validate_station(name, color, и_так_далее)
    errors = []

    errors << 'и_так_далее не может быть пустым. Введите!' if и_так_далее.empty?
    errors << 'Станция с таким цветом уже есть' if @stations[и_так_далее.to_sym]

    errors << 'Цвет станции не может быть пустым. Введите!' if color.empty?
    errors << 'Станция с таким цветом уже есть' if @stations[color.to_sym]

    errors << 'Название не может быть пустым. Повторите ввод!' if name.empty?
    errors << 'Станция с таким именем уже есть' if @stations[name.to_sym]

    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end
=end

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
    puts "\n Станция «#{station.name}» создана."
    puts "\n Обьект станции создан «#{station.inspect}»"
    puts "\n Станция сохранена в хеш станций «#{@stations}»"
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
    puts "\n Позд номер: «#{train.train_number}» создан."
    puts "\n Обьект поезд создан «#{train.inspect}»"
    puts "\n Поезд сохранен в хеш поездов «#{@trains}»"
  end

  # ###############    3 - добавление вагона к поезду #########################

  # проверка добавления вагона к поезду
  def attach_wagon
    if @trains.empty?
      puts 'Поезда отсутствуют, создайте поезд.'
    else
      request_info = ["Ввод номер поезда [#{@trains.keys.join(', ')}]: "]
      getting_info(request_info, :validate_train_selection, :attach_wagon!)
      puts "\n Вагон успешно прицеплен к поезду."
    end
  end

  # проверка правильности номера поезда
  def validate_train_selection(train_number)
    if @trains[train_number.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Поезд с таким номером отсутствует!' }
    end
  end

  # добавляем вагон к поезду
  def attach_wagon!(train_number)
    selected_train = select_train(train_number)
    wagon = if selected_train.type == 'cargo'
              CargoWagon.new
            else
              PassengerWagon.new
            end
    selected_train.add_wagon(wagon)
  end

  # ###############    4 - отцепка вагона от поезда ###########################

  # проверка возможности отцепить вагон
  def detach_wagon
    if @trains.empty?
      puts 'Поезда отсутствуют, создайте поезд.'
    else
      request_info = ["Ввод номер поезда [#{@trains.keys.join(', ')}]: "]
      getting_info(request_info, :validate_train_selection, :detach_wagon!)
      puts "\n Вагон успешно отцеплен от поезда."
    end
  end

  # метод validate_train_selection нажодиться в блоке методов выше

  # отцепка вагонa
  def detach_wagon!(train_number)
    select_train(train_number).delete_wagon
  end

  # ###############  5 - Помещение поезда на станцию ##########################

  # помещаем поезд на станцию
  def link_to_station
    if @trains.empty? || @stations.empty?
      puts 'Создайте минимум один поезд и минимум одну станцию'
    else
      request_info = ["Ввод номер поезда [#{@trains.keys.join(', ')}]: "]
      train = getting_info(request_info,
                           :validate_train_selection,
                           :select_train)
      request_info = ["Ввод название станции [#{@stations.keys.join(', ')}]: "]
      station = getting_info(request_info,
                             :validate_station_selection,
                             :select_station)
      station.arrive(train)
      puts "\n Поезд успешно помещен на станцию."
    end
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

  # ###############  6 - Посмотреть список станций ############################

  # список имеющихся станций
  def list_stations
    if @stations.empty?
      puts 'Создайте минимум одну станцию'
    else
      puts "\n Имеются следующее станции: [#{@stations.keys.join(', ')}]: "
    end
  end

  # ###############  7 - Посмотреть список поездов на станции   ###############

  # список поездов на выбранной станции
  def list_trains_on_station
    if @trains.empty? || @stations.empty?
      puts 'Создайте минимум один поезд и минимум одну станцию'
    else
      request_info = ["Ввод название станции [#{@stations.keys.join(', ')}]: "]
      station = getting_info(request_info,
                             :validate_station_selection,
                             :select_station)
      if station.trains.any?
        puts "\n На выбранной вами станции «#{station.name}» имеются поезда:"
        station.trains.each do |train|
          puts "N: «#{train.train_number}», тип: «#{train.type}», вагонов: «#{train.wagons.size}»"
        end
      else
        puts "\n На выбранной станции «#{station.name}» поезда отсутствуют."
      end
    end
  end

  # ###############   8 - Создать маршрут   ###################################

  # создаем маршрут
  def create_route
    if @stations.empty? || @stations.size < 2
      puts 'Станции отсутствуют или их меньше двух. Создайте мин. две станции.'
    else
      request_info = ["Ввод начальной станции [#{@stations.keys.join(', ')}]: ",
                      "Ввод конечной станции [#{@stations.keys.join(', ')}]: "]
      getting_info(request_info, :validate_stations_selection, :create_route!)
    end
  end

  # проверка станций для маршрута
  def validate_stations_selection(start_station, stop_station)
    if @stations[start_station.to_sym] && @stations[stop_station.to_sym]
      { success: true }
    else
      { success: false, 'errors': 'Станции нет или пустой ввод, повторите!' }
    end
  end

  # создание маршрута и записъ созданного маршрута в хеш маршрутов
  def create_route!(start_station, stop_station)
    route = Route.new(start_station, stop_station)
    @routes[route.name.to_sym] = route
    puts "Маршрут «#{route.name}» создан."
    puts "Маршрут сохранен в хеш маршрутов «#{@routes}»"
  end

  # ############### 9 - Добавитъ станцию в маршрут ############################

  # выбор маршрута и станции для добавления
  def add_station_in_to_route
    if @routes.empty?
      puts 'Маршруты отсутствуют, создайте маршрут.'
    else
      # вводим название маршрута
      request_info = ["Ввод название маршрута [#{@routes.keys.join(', ')}]: "]
      route = getting_info(request_info,
                           :validate_route_selection,
                           :select_route)
      # вводим название станции
      request_info = ["Ввод название станции [#{@stations.keys.join(', ')}]: "]
      station = getting_info(request_info,
                             :validate_station_selection_for_route,
                             :select_station)
      # добавляем станцию в маршрут!"
      route.add_station(station)
      puts 'Станция успешно добавлена к выбранному маршруту.'
    end
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
    puts "@stations[name.to_sym] #{@stations[name.to_sym]}"
    errors << 'Станция отсутствует!' if @stations[name.to_sym].nil?
    return unless @routes.include?(@stations[name.to_sym])
    errors << 'Такая станция уже есть в маршруте. Повторите ввод!'
    errors.empty? ? { success: true } : { success: false, 'errors': errors }
  end

  # список имеющихся маршрутов
  def show_all_routes
    if @routes.empty?
      puts 'Создайте минимум один маршрут'
    else
      puts BORDERLINE
      puts "Имеются следующее маршруты: [#{@routes.keys.join(', ')}]: "

      @routes.each { |route| puts route.inspect }
    end
  end

  # выбор маршрута и станции для удаления
  def delete_station_in_to_route
    if @routes.empty?
      puts 'Маршруты отсутствуют, создайте маршрут.'
    else
      # вводим название маршрута
      request_info = ["Ввод название маршрута [#{@routes.keys.join(', ')}]: "]
      route = getting_info(request_info,
                           :validate_route_selection,
                           :select_route)
      # вводим название станции
      # request_info = ["Ввод название станции [#{route.stations.each { |stations| print stations.name} }]: "]
      request_info = ["Ввод название станции [#{route.stations.name}]: "]
      station = getting_info(request_info,
                             :validate_station_selection_for_route,
                             :select_station)
      # добавляем станцию в маршрут!"
      route.delete_station(station)
      puts 'Станция успешно удалена в выбранном маршруте.'
    end
  end

  # проверка ввода маршрута
  def validate_route(name)
    errors = []
    errors << 'Станция отсутствует!' if @stations[name.to_sym].nil?
    errors << 'Начальная и конечная станция маршрута не могут совпадать. Повторите ввод!' if @routes_endings[0].name == name
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end

  # проверка ввода названия станции в маршруте
  def validate_route_name(name)
    errors = []
    errors << 'Маршрут с таким именем не существует, повторите ввод!' unless @routes[name.to_sym]
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end

end
