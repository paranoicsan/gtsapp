class SearchController < ApplicationController
  before_filter :require_user

  ##
  # Генерирует общую страницу для поиска
  #
  # GET /search
  def index
    respond_to do |format|
      format.html # index.html.haml
      format.json { head :ok }
    end
  end

  ##
  # Поиск компании
  #
  # GET search/search_company/do
  def search_company

    res = []

    # флаг, что какой-то поиск уже был
    searched = false

    # Флаги, какие поля поиска работают    
    fls = {
      email: params[:search_email].length > 0,         
      name: params[:search_name].length > 0,         
      phone: params[:search_phone].length > 0,
      address: {
        city: params[:select_search_city].length > 0,
        district: params[:select_search_district].length > 0,
        street: params[:select_search_street].length > 0,
        house: params[:search_house].length > 0,
        office: params[:search_office].length > 0,
        cabinet: params[:search_cabinet].length > 0
        }
    }

    search_by_address = fls[:address][:city] ||
        fls[:address][:district] ||
        fls[:address][:street] ||
        fls[:address][:house] ||
        fls[:address][:office] ||
        fls[:address][:cabinet]

    # если указан адрес электронной почты
    if  fls[:email] && Email.valid?(params[:search_email])
      em = Email.find_by_name params[:search_email]
      if em
        res << em.branch.company
      end
      searched = true
    end

    # Результаты поиска по всем типам названий НЕ ДОЛЖНЫ пересекаться
    # между собой - т.к. они ищутся по одному вводимому пользователем полю
    if fls[:name]
      found_by_name = []
      found_by_name.concat SearchController.search_by_name(params[:search_name])
      found_by_name.concat SearchController.search_by_branch_factname(params[:search_name])
      found_by_name.concat SearchController.search_by_branch_legelname(params[:search_name])
      found_by_name = found_by_name.uniq
      res = searched ? res & found_by_name : found_by_name
      searched = true
    end

    if search_by_address
      found_by_address = search_by_address(params, fls[:address])
      res = searched ? res & found_by_address : found_by_address
      searched = true
    end

    if fls[:phone]
      found_by_phone = SearchController.search_by_phone(params[:search_phone])
      res = searched ? res & found_by_phone : found_by_phone
    end

    # Убираем дубликаты, которые могут оставаться в массивах, которые не пересекаются
    @search_result = res.uniq

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  ## Пересекает массивы с сохранением при умножении на 0
  def array_intersect(array_first, array_second)
    if array_first.any?
      ar = array_second.any? ? array_first & array_second : array_first
    else
      ar = array_second
    end
    ar
  end

  def search_by_address(params, flags)
    ar = []

    # Флаг, что какой-либо поиск уже проводился. Отсюда можно судить, первоначальный массив
    # просто пустой или ничего не найдено.
    searched = false

    # город
    if flags[:city]
      found_by_city = SearchController.search_by_address_city(params[:select_search_city])
      ar = found_by_city
      searched = true
    end

    # район
    if flags[:district]
      found_by_district = SearchController.search_by_address_district(params[:select_search_district])
      ar = searched ? ar & found_by_district : found_by_district
      searched = true
    end

    # улица
    if flags[:street]
      found_by_street = SearchController.search_by_address_street(params[:select_search_street])
      ar = searched ? ar & found_by_street : found_by_street
      searched = true
    end

    # дом
    if flags[:house]
      found_by_house = SearchController.search_by_address_house(params[:search_house])
      ar = searched ? ar & found_by_house : found_by_house
      searched = true
    end

    # офис
    if flags[:office]
      found_by_office = SearchController.search_by_address_office(params[:search_office])
      ar = searched ? ar & found_by_office : found_by_office
      searched = true
    end

    # кабинет
    if flags[:cabinet]
      found_by_cabinet = SearchController.search_by_address_cabinet(params[:search_cabinet])
      ar = searched ? ar & found_by_cabinet : found_by_cabinet
    end

    ar
  end

  ##
  # Ищет по прямому названию
  # @param {String} Введённое имя
  # @return {Array} Коллекция найденных компаний
  def self.search_by_name(name)
    ar = []
    s = name.strip.mb_chars.downcase.gsub('%', '\%').gsub('_', '\_')
    if s.length > 0
      s = '%' + s + '%'
      res = Company.where('LOWER(title) LIKE ?', s)
      res.each { |c| ar << c }
    end
    ar
  end

  ##
  # Ищет по фактическому названию филиала
  # @param {String} Введённое имя
  # @return {Array} Коллекция найденных компаний
  def self.search_by_branch_factname(name)
    ar = []
    s = name.strip.mb_chars.downcase.gsub('%', '\%').gsub('_', '\_')
    if s.length > 0
      s = '%' + s + '%'
      res = Branch.where('LOWER(fact_name) LIKE ?', s)
      res.each { |c| ar << c.company }
    end
    ar
  end

  ##
  # Ищет по юридическому названию филиала
  # @param {String} Введённое имя
  # @return {Array} Коллекция найденных компаний
  def self.search_by_branch_legelname(name)
    ar = []
    s = name.strip.mb_chars.downcase.gsub('%', '\%').gsub('_', '\_')
    if s.length > 0
      s = '%' + s + '%'
      res = Branch.where('LOWER(legel_name) LIKE ?', s)
      res.each { |c| ar << c.company }
    end
    ar
  end

  ##
  # Ищет по названию города в зарегистрированных филиалах
  # @param {Integer} Ключ города
  # @return {Array} Коллекция найденных компаний
  def self.search_by_address_city(id)
    ar = []
    addresses = Address.find_all_by_city_id id
    addresses.each do |address|
      ar << address.branch.company
    end
    ar
  end

  ##
  # Ищет все компании, филиалы которых имеют адрес в указанному районе
  # @param {Integer} Ключ района
  # @return {Array} Коллекция найденных компаний
  def self.search_by_address_district(id)
    ar = []
    addresses = Address.find_all_by_district_id id
    addresses.each do |address|
      ar << address.branch.company
    end
    ar
  end

  ##
  # Ищет все компании, филиалы которых имеют адрес c выбранной улицей
  # @param {Integer} Ключ улицы
  # @return {Array} Коллекция найденных компаний
  def self.search_by_address_street(id)
    ar = []
    addresses = Address.find_all_by_street_id id
    addresses.each do |address|
      ar << address.branch.company
    end
    ar
  end

  ##
  # Ищет по номеру дома в адресах, зарегистрированных в филиалах компаний
  # @param {String} Введённый номер дома для поиска
  # @return {Array} Коллекция найденных компаний
  def self.search_by_address_house(name)
    ar = []
    house = name.strip.mb_chars.downcase.gsub('%', '\%').gsub('_', '\_')
    if house.length > 0
      addresses = Address.find_all_by_house house
      addresses.each do |address|
        ar << address.branch.company
      end
    end
    ar
  end

  ##
  # Ищет по номеру офиса в адресах, зарегистрированных в филиалах компаний
  # @param {String} Введённый номер
  # @return {Array} Коллекция найденных компаний
  def self.search_by_address_office(name)
    ar = []
    office = name.strip.mb_chars.downcase.gsub('%', '\%').gsub('_', '\_')
    if office.length > 0
      addresses = Address.find_all_by_office office
      addresses.each do |address|
        ar << address.branch.company
      end
    end
    ar
  end

  ##
  # Ищет по номеру кабинета в адресах, зарегистрированных в филиалах компаний
  # @param {String} Введённый номер
  # @return {Array} Коллекция найденных компаний
  def self.search_by_address_cabinet(name)
    ar = []
    cabinet = name.strip.mb_chars.downcase.gsub('%', '\%').gsub('_', '\_')
    if cabinet.length > 0
      addresses = Address.find_all_by_cabinet cabinet
      addresses.each do |address|
        ar << address.branch.company
      end
    end
    ar
  end

  ##
  # Ищет по номеру телефона в филиалах компаний
  # @param {String} Введённый номер
  # @return {Array} Коллекция найденных компаний
  def self.search_by_phone(name)
    ar = []
    s = name.strip.mb_chars.downcase.gsub('%', '\%').gsub('_', '\_')
    if s.length > 0
      s = s + '%'
      phones = Phone.where('LOWER(name) LIKE ?', s)
      phones.each { |p| ar << p.branch.company}
    end
    ar
  end

end
