# encoding: utf-8
class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  before_filter :create_default_vars
  protect_from_forgery

  # Сохраняет в сессии путь, куда хотят попасть
  def store_destination
    session[:return_to] = request.fullpath
  end

  # Сохраняет в сессии путь, откуда пришли
  def store_referrer
    session[:return_to] = request.referer
  end

  private
  ##
  # Создаёт глобюальные переменные
  def create_default_vars
    # Коллекция операций над объектами
    @object_operations = {
        product: {
            create: 'Продукт создан',
            update: 'Продукт изменён',
            destroy:'Продукт удалён'
        },
        contract: {
            create: 'Договор создан',
            update: 'Договор изменён',
            destroy:'Договор удалён'
        },
        person: {
            create: 'Персона создана',
            update: 'Персона изменена',
            destroy:'Персона удалена'
        },
        rubric: {
            add: 'Рубрика добавлена к компании',
            remove:'Рубрика удалена из компании'
        },
        address: {
            create: 'Адрес создан',
            update: 'Адрес изменён',
            destroy:'Адрес удалён'
        },
        branch: {
            create: 'Филиал создан',
            update: 'Филиал изменён',
            destroy:'Филиал удалён'
        },
        phone: {
            create: 'Телефон создан',
            update: 'Телефон изменён',
            destroy:'Телефон удалён'
        },
        website: {
            add: 'Веб-сайт добавлен',
            remove:'Веб-сайт удалён',
        },
        email: {
            add: 'Адрес электронной почты добавлен',
            remove:'Адрес электронной почты удалён',
        }
    }
  end

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

  # Проверяет, что это был системный пользователь,
  # либо администратор, либо оператор
  def require_system_users
    #noinspection RubyResolve
    unless @current_user.is_admin? || @current_user.is_operator?
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

  ##
  # Пишет историю компании
  # @param object [Symbol] Тип объекта, над которым выполняется операция
  # @param operation [Symbol] Название операции
  # @param company_id [Integer] Родительская компания
  def log_operation(object, operation, company_id)
    log_str = @object_operations[object][operation]
    CompanyHistory.log(log_str, current_user.id, company_id)
  end
end
