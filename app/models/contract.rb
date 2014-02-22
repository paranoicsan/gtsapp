# encoding: utf-8
class Contract < ActiveRecord::Base

  belongs_to :company
  belongs_to :contract_status
  belongs_to :project_code

  has_many :products, :dependent => :destroy
  has_many :product_types, :through => :products

  validates_presence_of :number, :message => 'Введите номер договора!'

  validates :number, :uniqueness => {:case_sensitive => false, message: 'Договор с таким номером уже существует!'}
  validates :amount, :numericality => { message: 'Сумма должна быть числовым значением!'}

  before_save :check_fields

  ##
  # Проверяет поля перед добавлением
  def check_fields
    self.created_at = Date.today
  end

  ##
  # Позволяет определить, может ли указанный пользоваитель удалить договор
  # @param [User] Пользователь
  # @return [Boolean] Истина, когда пользователь может удалить договор
  #
  #noinspection RubyResolve
  def can_delete?(user)
    user.is_admin? || user.is_operator? ? true : false
  end

  ##
  # Позволяет определить, может ли указанный пользоваитель активировать договор
  # @param [User] Пользователь
  # @return [Boolean] Истина, когда пользователь может активировать договор
  #
  #noinspection RubyResolve
  def can_activate?(user)
    (user.is_admin? || user.is_operator?) && !self.active? ? true : false
  end

  ##
  #
  # Активирует указанный договор
  #
  # @param [Integer] Ключ договора
  def self.activate(contract_id)
    c = Contract.find contract_id
    c.update_attribute :contract_status, ContractStatus.active
    c.save
  end

  ##
  # Определяет, активный ли договор
  #
  # @return [Boolean] Истина, если договор активен
  def active?
    self.contract_status == ContractStatus.active
  end

  ##
  # выводит указанную информацию в виде строки
  # № 7, заключен: 01.01.2012, пакет «Лого», «Цветная страница в рубрике», cумма: 25000
  # @return [String] Отформатрованную строку с информацией о договоре
  def info
    s = "№ #{number}, "
    s = "#{s}#{project_code.name}, " unless project_code.nil?
    s = "#{s}заключён: #{date_sign.strftime("%d.%m.%Y")}, " unless date_sign.nil?

    # обрабатываем продукты
    if products.any?
      products.each do |p|
        s = %Q{#{s}"#{p.product_type.name}", }
      end
    end

    %Q{#{s}сумма: #{amount}руб.}
  end
end
