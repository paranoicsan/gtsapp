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
    @search_result = [] # коллекция с результатами поиска

    # если указан адрес электронной почты
    if Email.valid? params[:search_email]
      em = Email.find_by_name params[:search_email]
      if em && !@search_result.include?(em.branch.company)
        @search_result << em.branch.company
      end
    end

    # Прямое название
    res = SearchController.search_by_name(params[:search_name])
    @search_result.concat(res)  if res.any?

    # Фактическое название по филиалу
    #res = SearchController.search_by_branch_factname(params[:search_name])
    #@search_result.concat(res)  if res.any?

    # убираем дубликаты
    @search_result = @search_result.uniq

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
      ar.concat(res) if res.any?
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
      ar.concat(res) if res.any?
    end
    ar
  end

end
