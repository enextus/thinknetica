# frozen_string_literal: true

# Программа позволяет пользователю через текстовый интерфейс делать следующее:
#
# 1 - Создавать станции
# 2 - Создавать поезда
# 3 - Добавлять вагоны к поезду
# 4 - Отцеплять вагоны от поезда
# 5 - Поместить поезд на станцию
# 6 - Просматривать список станций
# 7 - список поездов на станции

# 8 - Создавать маршруты
# 9 - добавлять станцию в маршрут (и управлять станциями в нем (добавлять, удалять))
# 10 - удалитъ станцию в маршруте (и управлять станциями в нем (добавлять, удалять))
# 11 - добавлять маршрут
# 12 - удалять маршрут
# 13 - Назначать маршрут поезду
# 14 - Перемещать поезд по маршруту вперед и назад

# class AppController
class AppController

  attr_reader :stations, :trains, :routes, :wagons

  def initialize
    @stations = Hash.new
    @trains = Hash.new
    @routes = Hash.new
  end

  def show_actions
    puts "Выберите желаемое действие, введя условный номер из списка: "
    puts " 1 - Создать станцию"
    puts " 2 - Создать поезд"
    puts " 3 - Прицепить к поезду вагон"
    puts " 4 - Отцепить вагон от поезда"
    puts " 5 - Поместить поезд на станцию"
    puts " 6 - Посмотреть список станций"
    puts " 7 - Посмотреть список поездов на станции"
    puts " 8 - Создать маршрут"
    puts " 9 - Добавитъ станцию в маршрут"
    puts " 10 - Удалитъ станцию в маршруте"
    puts " 11 - Добавлять маршрут"
    puts " 12 - Удалять маршрут"
    puts " 13 - Назначать маршрут поезду"
    puts " 14 - Перемещать поезд по маршруту вперед и назад"
    puts BORDERLINE;
    puts "Для выхода из меню введите: exit"
    puts BORDERLINE;
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
      list_trains_on_select_station
    else
      puts "Повторите ввод!"
    end
    puts BORDERLINE;
  end

  private

  # создание станции с валидацией ввода
  def create_station
    request_info = ["Введите название станции: "]
    getting_info(request_info, :validate_station, :create_station!)
  end

  # создание поезда с валидацией ввода
  def create_train
    request_info = ["Укажите тип поезда (1 - пассажирский, 2 - грузовой): ",
    "Введите номер поезда: "]
    getting_info(request_info, :validate_train, :create_train!)
  end

  # валидатор ввода текстовой информации и формирование меню,
  # нагло скопирован в сети, изучен и почти понят
  def getting_info(request_info, validator, success_callback)
    response = nil
    loop do
      args = []
      request_info.each do |message|
        print "#{message}"
        args << gets.chomp
      end

      check = self.send(validator, *args)
      if check[:success]
        response = self.send(success_callback, *args)
        break
      else
        puts check[:errors]
      end
    end
    response
  end

  # проверка ввода названия станции
  def validate_station(name)
    errors = []
    errors << 'Название станции не может быть пустым. Повторите ввод!' if name.empty?
    errors << 'Станция с таким именем уже есть' if @stations[name.to_sym]
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
  end

  # записъ созданной станции в хеш станций
  def create_station!(name)
    station = Station.new(name)
    @stations[name.to_sym] = station
    puts "Станция «#{station.name}» создана."
    puts "Обьект станции создан «#{station.inspect}»"
    puts "Станция сохранена в хеш станций «#{@stations}»"
  end

  # проверка ввода названия и типа поезда
  def validate_train(type, train_number)
    errors = []
    valid_types = ["1", "2"]
    errors << "Номер поезда не может быть пуст!" if train_number.empty?
    errors << "Некорректный тип поезда! Выберите 1 или 2" if !valid_types.include?(type)
    errors << "Поезд с таким номером уже есть" if @trains[train_number.to_sym]
    errors.empty? ? {success: true} : {success: false, 'errors': errors}
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
    puts "Позд номер: «#{train.train_number}» создан."
    puts "Обьект поезд создан «#{train.inspect}»"
    puts "Поезд сохранен в хеш поездов «#{@trains}»"
  end

  def attach_wagon
    if @trains.empty?
      puts 'Поезда отсутствуют, создайте поезд.'
    else
      request_info = ["Введите номер поезда [#{@trains.keys.join(', ')}]: "]
      getting_info(request_info, :validate_train_selection, :attach_wagon!)
      puts 'Вагон успешно прицеплен к поезду.'
    end
  end

  def validate_train_selection(train_number)
    if @trains[train_number.to_sym]
      {success: true}
    else
      {success: false, 'errors': "Поезд с таким номером отсутствует!"}
    end
  end

  def attach_wagon!(train_number)
    selected_train = select_train(train_number)
    case selected_train.type
    when 'cargo'
      wagon = CargoWagon.new
    else
      wagon = PassengerWagon.new
    end
    selected_train.add_wagon(wagon)
  end

  def select_train(train_number)
    selected_train = @trains[train_number.to_sym]
  end

  # Отцепить вагон
  def detach_wagon
    if @trains.empty?
      puts 'Поезда отсутствуют, создайте поезд.'
    else
      request_info = ["Введите номер поезда [#{@trains.keys.join(', ')}]: "]
      getting_info(request_info, :validate_train_selection, :detach_wagon!)
      puts 'Вагон успешно отцеплен от поезда.'
    end
  end

  def detach_wagon!(train_number)
    selected_train = select_train(train_number)
    selected_train.delete_wagon
  end

  def link_to_station
    if @trains.empty? || @stations.empty?
      puts 'Создайте минимум один поезд и минимум одну станцию'
    else
      request_info = ["Введите номер поезда [#{@trains.keys.join(', ')}]: "]
      train = getting_info(request_info, :validate_train_selection, :select_train)
      request_info = ["Введите название станции [#{@stations.keys.join(', ')}]: "]
      station = getting_info(request_info, :validate_station_selection, :select_station)
      station.arrive(train)
      puts 'Поезд успешно помещен на станцию.'
    end
  end

  def select_station(name)
    selected_station = @stations[name.to_sym]
  end

  def validate_station_selection(name)
    if @stations[name.to_sym]
      {success: true}
    else
      {success: false, 'errors': 'Станция отсутствует!'}
    end
  end

  def list_stations
    if @stations.empty?
      puts 'Создайте минимум одну станцию'
    else
      puts BORDERLINE;
      puts "Имеются следующее станции: [#{@stations.keys.join(', ')}]: "
    end
  end

  def list_trains_on_select_station
    if @trains.empty? || @stations.empty?
      puts 'Создайте минимум один поезд и минимум одну станцию'
    else
      request_info = ["Введите название станции [#{@stations.keys.join(', ')}]: "]
      station = getting_info(request_info, :validate_station_selection, :select_station)
        if station.trains.any?
          puts BORDERLINE;
          puts "На выбранной вами станции «#{station.name}» имеются поезда:"
          station.trains.each do |train|
            puts "Номер позда: «#{train.train_number}», тип поезда: «#{train.type}»"
          end
        else
          puts BORDERLINE;
          puts "На выбранной вами станции «#{station.name}» поезда отсутствуют."
        end
    end
  end
end
