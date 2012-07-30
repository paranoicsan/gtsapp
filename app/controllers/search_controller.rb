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
    res = [] # коллекция с результатами поиска

    # если указан адрес электронной почты
    if Email.valid? params[:search_email]
      em = Email.find_by_name params[:search_email]
      if em && !res.include?(em.branch.company)
        res << em.branch.company
      end
    end

    # поиск по телефону
    res.concat SearchController.search_by_phone(params[:search_phone])

    # Результаты поиска по всем типам названий НЕ ДОЛЖНЫ пересекаться
    # между собой - т.к. они ищутся по одному вводимому пользователем полю

    found_by_name = []
    found_by_name.concat SearchController.search_by_name(params[:search_name])
    found_by_name.concat SearchController.search_by_branch_factname(params[:search_name])
    found_by_name.concat SearchController.search_by_branch_legelname(params[:search_name])

    found_by_address = []
    found_by_address.concat SearchController.search_by_address_city(params[:select_search_city])
    found_by_address.concat SearchController.search_by_address_district(params[:select_search_district])
    found_by_address.concat SearchController.search_by_address_street(params[:select_search_street])
    found_by_address.concat SearchController.search_by_address_house(params[:search_house])
    found_by_address.concat SearchController.search_by_address_office(params[:search_office])
    found_by_address.concat SearchController.search_by_address_cabinet(params[:search_cabinet])



    # Проверка, есть ли уже результаты поиска по предыдущим полям
    # Полный набор получаем пересечением массивов
    if res.any?
      res = res & found_by_name if found_by_name.any?
      res = res & found_by_address if found_by_address.any?
    else
      res = found_by_name
      if res.any?
        res = res & found_by_address if found_by_address.any?
      else
        res = found_by_address
      end
    end

    # Убираем дубликаты, которые могут оставаться в массивах, которые не пересекаются
    @search_result = res.uniq

    respond_to do |format|
      format.js { render :layout => false }
    end
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
