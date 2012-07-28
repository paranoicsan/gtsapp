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

    # Результаты поиска по всем типам названий НЕ ДОЛЖНЫ пересекаться
    # между собой - т.к. они ищутся по одному вводимому пользователем полю

    found_by_name = []
    found_by_name.concat SearchController.search_by_name(params[:search_name])
    found_by_name.concat SearchController.search_by_branch_factname(params[:search_name])
    found_by_name.concat SearchController.search_by_branch_legelname(params[:search_name])

    found_by_address = []
    found_by_address.concat SearchController.search_by_address_city(params[:search_city])
    found_by_address.concat SearchController.search_by_address_district(params[:select_search_district])

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
  # @param {String} Название города
  # @return {Array} Коллекция найденных компаний
  def self.search_by_address_city(name)
    ar = []
    city_name = name.strip.mb_chars.downcase.gsub('%', '\%').gsub('_', '\_')
    if city_name.length > 0

      city_name = '%' + city_name + '%'
      cities = City.where('LOWER(name) LIKE ?', city_name) # все города с похожим названием

      addresses = [] # здесь лежат все адреса, связанные с такими городами
      cities.each do |city|
        addresses.concat Address.find_all_by_city_id(city.id)
      end

      branches = [] # по адресам достаём филиалы
      addresses.each { |address| branches << address.branch }

      branches.each { |b| ar << b.company }
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

end
