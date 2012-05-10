# encoding: utf-8
class Company < ActiveRecord::Base
  belongs_to :company_status
  belongs_to :user
  has_many :branches
  validates_presence_of :title
  before_save :check_fields
  scope :suspended, where(:company_status_id => CompanyStatus.suspended.id)

  # Возвращает истину, если компания владеет только социальным рубрикатором
  def social_rubricator?
    self.rubricator == 1
  end

  # Возвращает истину, если компания владеет только коммерческим рубрикатором
  def commercial_rubricator?
    self.rubricator == 2
  end

  # Возвращает истину, если компания входит во все рубрикаторы
  def full_rubricator?
    self.rubricator == 3
  end

  ##
  #
  # Проверяет и обрабатывает поля перед непосредственной записью в БД
  #
  def check_fields
    # Если дату не заполнили, подставляем сегодняшний день
    unless self.date_added
      self.date_added = Date.today
    end
  end

  # Выводит текстовое обозначение рубриктора для компании
  # @return [string] Текстовое значение рубрикатора
  def rubricator_name
    case self.rubricator
      when 1 then "Социальный"
      when 2 then "Коммерческий"
      when 3 then "Полный"
      else
        "Не указан"
    end
  end

  ##
  #
  # Возвращает автора компании
  #
  # @return [String] Автор компании
  def author
    s = ""
    if self.author_user_id
      s = User.find(self.author_user_id).username
    end
    s
  end

  ##
  #
  # Возвращает редактора компании
  #
  # @return [String] Редактор компании
  def editor
    s = ""
    if self.editor_user_id
      s = User.find(self.editor_user_id).username
    end
    s
  end

  ##
  #
  # Активирует указанную компанию
  #
  # @param [Integer] Ключ компании
  def self.activate(company_id)
    c = Company.find company_id
    c.update_attribute :company_status_id, CompanyStatus.active
    c.save
  end

  ##
  #
  # Определяет, активна ли компания
  #
  # @return [Boolean] Активна ли компания
  def active?
    self.company_status_id == CompanyStatus.active.id
  end

  ##
  #
  # Отсортированный набор филиалов
  #
  # @return [Array] Коллекция филиалов
  def branches_sorted
    self.branches.order("is_main DESC, fact_name ASC")
  end

  def self.suspended_by_user(user_id)
    Company.where("author_user_id = ? and company_status_id = ?", user_id, CompanyStatus.suspended.id)
  end

end
