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

    # Проверка, есть ли уже результаты поиска по предыдущим полям
    if res.any?
      res = res & found_by_name if found_by_name.any?
    else
      res = found_by_name
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


end
