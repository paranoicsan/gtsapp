module ApplicationHelper

  # Сохраняет в сессии путь, куда хотят попасть
  def store_destination
    session[:return_to] = request.fullpath
  end

  # Сохраняет в сессии путь, откуда пришли
  def store_referrer
    session[:return_to] = request.referer
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
