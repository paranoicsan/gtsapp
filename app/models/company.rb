# encoding: utf-8
#noinspection RubyTooManyMethodsInspection
class Company < ActiveRecord::Base
  belongs_to :company_status
  belongs_to :company_source
  belongs_to :agent, :class_name => 'User', :foreign_key => "agent_id"
  belongs_to :author, :class_name => 'User', :foreign_key => "author_user_id"
  belongs_to :editor, :class_name => 'User', :foreign_key => "editor_user_id"
  has_many :company_histories, :dependent => :destroy
  has_many :contracts, :dependent => :destroy
  has_many :branches, :dependent => :destroy
  has_many :persons, :dependent => :destroy
  has_many :company_rubrics, :dependent => :destroy
  has_many :rubrics, :through => :company_rubrics
  validates_presence_of :title
  validates_presence_of :reason_deleted_on, :if => :queued_for_deletion?, :message => 'Не указана причина удаления'
  validates_presence_of :reason_need_attention_on, :if => :need_attention?, :message => 'Не указана причина обращения'
  validates_presence_of :reason_need_improvement_on, :if => :need_improvement?, :message => 'Не указана причина необходимости доработки компании'
  #noinspection RailsParamDefResolve
  before_save :check_fields, only: [:create]

  def self.suspended
    where(:company_status_id => CompanyStatus.suspended.id)
  end

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
  # Проверяет и обрабатывает поля перед непосредственной записью в БД
  def check_fields
    self.date_added = Date.today unless self.date_added

    if self.company_status_id
      self.company_status = CompanyStatus.find self.company_status_id
    else
      #noinspection RubyResolve
      self.company_status = CompanyStatus.active if self.author.is_admin?
      #noinspection RubyResolve
      self.company_status = CompanyStatus.active if self.author.is_operator?
      #noinspection RubyResolve
      self.company_status = CompanyStatus.suspended if self.author.is_agent?
    end
  end

  # Выводит текстовое обозначение рубриктора для компании
  # @return [string] Текстовое значение рубрикатора
  def rubricator_name
    Rubric.rubricator_name_for rubricator
  end

  ##
  # Возвращает автора компании
  # @return [String] Автор компании
  def author_name
    s = ""
    if self.author_user_id
      s = User.find(self.author_user_id).username
    end
    s
  end

  ##
  # Возвращает редактора компании
  # @return [String] Редактор компании
  def editor_name
    s = ""
    if self.editor_user_id
      s = User.find(self.editor_user_id).username
    end
    s
  end

  ##
  # Активирует указанную компанию
  # @param [Integer] Ключ компании
  def self.activate(company_id)
    c = Company.find company_id
    c.update_attributes({
                            :company_status_id => CompanyStatus.active.id,
                            :reason_need_attention_on => nil,
                            :reason_deleted_on => nil,
                            :reason_need_improvement_on => nil
                        })
    c.save
  end

  ##
  # Определяет, активна ли компания
  # @return [Boolean] Активна ли компания
  def active?
    self.company_status_id == CompanyStatus.active.id
  end

  ##
  # Отсортированный набор филиалов
  # @return [Array] Коллекция филиалов
  def branches_sorted
    self.branches.order("is_main DESC, fact_name ASC")
  end

  def self.suspended_by_user(user_id)
    Company.where("author_user_id = ? and company_status_id = ?", user_id, CompanyStatus.suspended.id)
  end

  ##
  # Определяет имя источника информации
  # @return [String] Отформатированное значение источника информации
  def source_name
    if company_source
      CompanySource.find(self.company_source_id).name
    else
      "Не указан"
    end
  end

  ##
  # Определяет, имеет ли компании источник "От агента"
  # @return [Boolean] Истина, если компания имеет источник "От агента"
  def from_agent?
    company_source_id == CompanySource.from_agent_id
  end

  ##
  # Возвращает агента компании
  # @return [String] Агент компании
  def agent_name
    if agent_id
      User.find(self.agent_id).username
    end
  end

  ##
  # Помечает компанию как помеченную на удаление,
  # путём замены статуса
  def queue_for_delete(reason = nil)
    self.company_status = CompanyStatus.queued_for_delete
    self.reason_deleted_on = reason
  end

  ##
  # Отменяет постановку н удаление и меняет статус компании на указанный
  def unqueue_for_delete(new_status)
    unless queued_for_deletion?
      return
    end

    case new_status
      when :active
        s = CompanyStatus.active
      when :suspended
        s = CompanyStatus.suspended
      when :archived
        return
      else
        raise "Неизвестный статус"
    end
    self.company_status = s
  end

  ##
  # Определяет, поставлена ли компания на удаление
  # @return [Boolean] Истина, если компания поставлена на удаление
  def queued_for_deletion?
    company_status ? company_status.eql?(CompanyStatus.queued_for_delete) : false
  end

  ##
  # Возвращает коллекцию всех компаний, поставленных на удаление
  # @return [Array] коллекции на удалении
  def self.queued_for_delete
    Company.where(:company_status_id => CompanyStatus.queued_for_delete.id)
  end

  ##
  # Определяет, поставлена ли компания на статус как требующая внимания со стороны администратора
  # @return [Boolean] Истина, если компания требует внимания
  def need_attention?
    company_status ? company_status.eql?(CompanyStatus.need_attention) : false
  end

  ##
  # Возвращает коллекцию всех компаний, с запрошенным вниманием
  # @return [Array] коллекции на удалении
  def self.need_attention_list
    Company.where(:company_status_id => CompanyStatus.need_attention.id)
  end

  ##
  # Возвращает коллекцию всех компаний на доработке
  # @return [Array] коллекция компаний
  def self.need_improvement_list
    Company.where(:company_status_id => CompanyStatus.need_improvement.id)
  end

  ##
  # Возвращает коллекцию всех компаний на доработке для конкретного пользователя
  # @@param [Integer] Ключ пользователя
  # @return [Array] коллекция компаний
  def self.need_improvement_list_by_user(id)
    Company.where(:company_status_id => CompanyStatus.need_improvement.id,
    :author_user_id => id)
  end

  ##
  # Определяет, поставлена ли компания на статус как требующая доработки агентом
  # @return [Boolean] Истина, если компания требует доработки
  def need_improvement?
    company_status ? company_status.eql?(CompanyStatus.need_improvement) : false
  end

  ##
  # Определяет, поставлена ли компания в архив
  # @return [Boolean] Истина, если компания находится в архиве
  def archived?
    company_status ? company_status.eql?(CompanyStatus.archived) : false
  end

  ##
  # Меняет для компании статус на архивный
  def archive
    update_attributes({
                          :company_status_id => CompanyStatus.archived.id,
                          :reason_need_attention_on => nil,
                          :reason_deleted_on => nil,
                          :reason_need_improvement_on => nil
                      })
  end

  ##
  # Определяет, может ли компанию активировать агент
  # @return [Boolean] Истину, если можно активировать
  def can_be_activated_by_agent?
    company_status_id.eql?(CompanyStatus.archived.id)
  end

  ##
  # Возвращает головной филиал для компании
  def main_branch
    Branch.where("company_id = ? and is_main = true", id).first
  end

  ##
  # Возвращает масив компаний, чьи головные филиалы лежат на улице
  def self.by_street(street_id, options)
    companies = []
    Address.by_street(street_id).each do |a|
      if a.branch.is_main
        c = a.branch.company

        # для полного рубрикатора всегда есть попадание в любое условие
        if c.rubricator.eql?(options[:rubricator_filter].to_i) || c.rubricator.eql?(3)
          if options[:filter] == "active"
            companies << c if c.active?
          else
            companies << c
          end
        end
      end
    end
    companies
  end

end
