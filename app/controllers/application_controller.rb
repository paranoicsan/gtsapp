# encoding: utf-8
class ApplicationController < ActionController::Base

  before_filter :authenticate_user!,
                :create_default_vars

  protect_from_forgery

  private

  ##
  # Создаёт глобюальные переменные
  #
  # TODO: Вынести в отдельный сервис
  def create_default_vars
    # Коллекция операций над объектами
    @object_operations ||= {
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
        },
        company: {
            create: 'Создана компания',
            update: 'Компания обновлена'
        }
    }
  end

  ##
  # Пишет историю компании
  # @param object [Symbol] Тип объекта, над которым выполняется операция
  # @param operation [Symbol] Название операции
  # @param company_id [Integer] Родительская компания
  def log_operation(object, operation, company_id)
    log_str = @object_operations[object][operation]
    Companies::History.log(log_str, current_user.id, company_id)
  end
end
