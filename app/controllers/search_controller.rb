class SearchController < ApplicationController
  before_filter :require_user

  ##
  # Генерирует общую страницу для поиска
  #
  # GET /search
  def index

  end

end
