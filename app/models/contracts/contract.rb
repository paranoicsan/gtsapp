class Contracts::Contract < ActiveRecord::Base

  belongs_to :company, class_name: 'Companies::Company'
  belongs_to :status, foreign_key: 'contracts_statuses_id'
  belongs_to :code, foreign_key: 'contracts_codes_id'

  has_many :products, :dependent => :destroy
  has_many :product_types, :through => :products

  validates_presence_of :number, :message => 'Введите номер договора!'

  validates :number, uniqueness: {case_sensitive: false, message: 'Договор с таким номером уже существует!'}
  validates :amount, numericality: {message: 'Сумма должна быть числовым значением!'}

  ##
  # Позволяет определить, может ли указанный пользоваитель удалить договор
  # @param [User] Пользователь
  # @return [Boolean] Истина, когда пользователь может удалить договор
  #
  def can_delete?(user)
    user.is_admin? || user.is_operator? ? true : false
  end

  ##
  # Позволяет определить, может ли указанный пользоваитель активировать договор
  # @param [User] Пользователь
  # @return [Boolean] Истина, когда пользователь может активировать договор
  #
  def can_activate?(user)
    (user.is_admin? || user.is_operator?) && !self.active? ? true : false
  end

  ##
  #
  # Активирует указанный договор
  #
  # @param [Integer] Ключ договора
  #
  def self.activate(contract_id)
    c = self.find contract_id
    c.update_attributes contract_status: Status.active
  end

  ##
  # Определяет, активный ли договор
  #
  # @return [Boolean] Истина, если договор активен
  #
  def active?
    self.status == Status.active
  end

  ##
  # выводит указанную информацию в виде строки
  # № 7, заключен: 01.01.2012, пакет «Лого», «Цветная страница в рубрике», cумма: 25000
  # @return [String] Отформатрованную строку с информацией о договоре
  def
  info
    s = "№ #{number}, "
    s = "#{s}#{code.name}, " unless code.nil?
    s = "#{s}заключён: #{date_sign.strftime('%d.%m.%Y')}, " unless date_sign.nil?

    # обрабатываем продукты
    if products.any?
      s += products.map{|p| "'#{p.product_type.name}'"}.join(', ')
      s += ', '
    end

    %Q{#{s}сумма: #{amount}руб.}
  end
end
