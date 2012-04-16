# encoding: utf-8
class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  protect_from_forgery

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  # Проверяет, авторизован ли пользователь
  # в противном случае пренправляет на страницу авторизации
  def require_user
    unless current_user
      store_destination
      flash[:error] = %{Необходимо авторизоваться в системе.}
      #noinspection RubyResolve
      redirect_to login_url
      false
    end
  end

  # Проверяет, чтобы пользователь был администратором
  def require_admin
    #noinspection RubyResolve
    unless @current_user.is_admin?
      store_referrer
      flash[:error] = %{У Вас недостаточно прав для доступа к запрошенной странице.}
      redirect_back_or_default(dashboard_url)
      false
    end
  end

  # Проверяет, чтобы пользователь был оператором
  def require_operator
    #noinspection RubyResolve
    unless @current_user.is_operator?
      store_referrer
      flash[:error] = %{У Вас недостаточно прав для доступа к запрошенной странице.}
      redirect_back_or_default(dashboard_url)
      false
    end
  end

  # Осуществляет перенаправление уже авторизованного пользователя
  # @return [Boolean] false если пользователь не авторизован
  def redirect_logged_in
    if current_user ; #noinspection RubyResolve
    redirect_back_or_default(dashboard_url) end
    false
  end


  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
