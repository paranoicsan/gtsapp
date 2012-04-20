module GeneralHelpers

  ##
  #
  # Возвращает текущий путь
  #
  # @return [String] Путь, на котором сейчас находится дравйвер capybara
  def current_path
    URI.parse(current_url).path
  end


end

World(GeneralHelpers)