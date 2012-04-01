module ApplicationHelper

  # Сохраняет в сессии путь, куда хотят попасть
  def store_destination
    session[:return_to] = request.fullpath
  end

  # Сохраняет в сессии путь, откуда пришли
  def store_referrer
    session[:return_to] = request.referer
  end

end
