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

    # Ищем по названиям
    @search_result.concat SearchController.search_by_name(params[:search_name])
    puts @search_result.inspect

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  ##
  #
  # @param {String} Введённое имя
  # @return {Array} Коллекция найденных компаний
  def self.search_by_name(name)
    ar = []
    s = name.strip.mb_chars.downcase.gsub('%', '\%').gsub('_', '\_')
    if s.length > 0
      s = '%' + s + '%'
      ar << Company.where('LOWER(title) LIKE ?', s)
    end
    ar
  end

end
