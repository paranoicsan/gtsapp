# == Schema Information
#
# Table name: companies_companies
#
#  id                         :integer          not null, primary key
#  title                      :string(255)
#  date_added                 :date
#  rubricator                 :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  companies_status_id        :integer
#  author_user_id             :integer
#  editor_user_id             :integer
#  companies_source_id        :integer
#  agent_id                   :integer
#  comments                   :string(255)
#  reason_deleted_on          :string(255)
#  reason_need_attention_on   :string(255)
#  reason_need_improvement_on :string(255)
#
# Indexes
#
#  index_companies_companies_on_id  (id)
#

# TODO: Вынести некоторые методы в отдельный модуль
module Companies

  class Company < ActiveRecord::Base

    belongs_to :status, foreign_key: :companies_status_id
    belongs_to :source, foreign_key: :companies_source_id
    belongs_to :agent, class_name: 'Users::User', foreign_key: 'agent_id'
    belongs_to :author, class_name: 'Users::User', foreign_key: 'author_user_id'
    belongs_to :editor, class_name: 'Users::User', foreign_key: 'editor_user_id'
    has_many :histories, dependent: :destroy
    has_many :contracts, dependent: :destroy, class_name: 'Contracts::Contract'
    has_many :branches, dependent: :destroy, class_name: 'Branches::Branch'
    has_many :persons, dependent: :destroy
    has_and_belongs_to_many :rubrics, class_name: 'Rubrics::Rubric',
                            join_table: 'companies_rubrics_join'

    validates_presence_of :title
    validates_presence_of :rubricator

    validates_presence_of :reason_deleted_on, if: :queued_for_deletion?,
                          message: 'Не указана причина удаления'
    validates_presence_of :reason_need_attention_on, if: :need_attention?,
                          message: 'Не указана причина обращения'
    validates_presence_of :reason_need_improvement_on, if: :need_improvement?,
                          message: 'Не указана причина необходимости доработки компании'

    before_save :default_values, if: :new_record?

    scope :active, -> { where companies_status_id: Status.active.id }
    scope :archived, -> { where companies_status_id: Status.archived.id }
    scope :suspended, -> { where companies_status_id: Status.suspended.id }
    scope :need_improvement, -> { where companies_status_id: Status.need_improvement.id }
    scope :need_improvement_by_user, ->(id) { where companies_status_id: Status.need_improvement, author_user_id: id }
    scope :suspended_by_user, ->(id) { where companies_status_id: Status.suspended, author_user_id: id}
    scope :queued_for_delete, -> { where companies_status_id: Status.queued_for_delete.id }
    scope :need_attention, -> { where companies_status_id: Status.need_attention.id }

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

    # Выводит текстовое обозначение рубриктора для компании
    # @return [string] Текстовое значение рубрикатора
    def rubricator_name
      rubricator.nil? || (rubricator == 0) ? 'Не указан' : Rubrics::Rubric.rubricator_name_for(rubricator)
    end

    ##
    # Возвращает автора компании
    # @return [String] Автор компании
    def author_name
      s = ''
      if self.author_user_id
        s = User.find(self.author_user_id).username
      end
      s
    end

    ##
    # Возвращает редактора компании
    # @return [String] Редактор компании
    def editor_name
      s = ''
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
                              status: Status.active,
                              reason_need_attention_on: nil,
                              reason_deleted_on: nil,
                              reason_need_improvement_on: nil
                          })
    end

    ##
    # Определяет, активна ли компания
    # @return [Boolean] Активна ли компания
    def active?
      status.eql?(Status.active)
    end

    ##
    # Отсортированный набор филиалов
    # @return [Array] Коллекция филиалов
    def branches_sorted
      branches.order('is_main DESC, fact_name ASC')
    end

    ##
    # Определяет имя источника информации
    # @return [String] Отформатированное значение источника информации
    def source_name
      ! source.nil? ? source.name : 'Не указан'
    end

    ##
    # Определяет, имеет ли компании источник "От агента"
    # @return [Boolean] Истина, если компания имеет источник "От агента"
    def from_agent?
      source.id == Source.from_agent_id
    end

    ##
    # Возвращает агента компании
    # @return [String] Агент компании
    def agent_name
      User.find(agent_id).try :username
    end

    ##
    # Помечает компанию как помеченную на удаление,
    # путём замены статуса
    def queue_for_delete(reason = nil)
      update_attributes status: Status.queued_for_delete,
                        reason_deleted_on: reason
    end

    ##
    # Отменяет постановку н удаление и меняет статус компании на указанный
    def unqueue_for_delete(new_status)

      unless queued_for_deletion?
        return
      end

      case new_status
        when :active
          s = Status.active
        when :suspended
          s = Status.suspended
        when :archived
          return
        else
          raise 'Неизвестный статус'
      end
      update_attributes status: s
    end

    ##
    # Определяет, поставлена ли компания на удаление
    # @return [Boolean] Истина, если компания поставлена на удаление
    def queued_for_deletion?
      status.eql?(Status.queued_for_delete)
    end

    ##
    # Определяет, поставлена ли компания на статус как требующая внимания со стороны администратора
    # @return [Boolean] Истина, если компания требует внимания
    def need_attention?
      status.eql?(Status.need_attention)
    end

    ##
    # Определяет, поставлена ли компания на статус как требующая доработки агентом
    # @return [Boolean] Истина, если компания требует доработки
    def need_improvement?
      status.eql?(Status.need_improvement)
    end

    ##
    # Определяет, поставлена ли компания в архив
    # @return [Boolean] Истина, если компания находится в архиве
    def archived?
      status.eql?(Status.archived)
    end

    ##
    # Меняет для компании статус на архивный
    def archive
      update_attributes({
                            status: Status.archived,
                            reason_need_attention_on: nil,
                            reason_deleted_on: nil,
                            reason_need_improvement_on: nil
                        })
    end

    ##
    # Определяет, может ли компанию активировать агент
    # @return [Boolean] Истину, если можно активировать
    def can_be_activated_by_agent?
      status.eql?(Status.archived)
    end

    ##
    # Возвращает головной филиал для компании
    def main_branch
      branches.select{ |b| b.is_main }.first
    end

    ##
    # Возвращает масив компаний, чьи головные филиалы лежат на улице
    def self.by_street(street_id, options)
      companies = []
      Addresses::Address.by_street(street_id).each do |a|
        # noinspection RubyResolve
        if a.branch.is_main
          c = a.branch.company

          # для полного рубрикатора всегда есть попадание в любое условие
          if c.rubricator.eql?(options[:rubricator_filter].to_i) || c.rubricator.eql?(3)
            case options[:filter].to_s
              when 'active'
                companies << c if c.active?
              when 'archived'
                companies << c if c.archived?
              else
                companies << c
            end
          end
        end
      end
      companies
    end

    private

    ##
    # Проверяет и обрабатывает поля перед непосредственной записью в БД
    def default_values

      self.date_added ||= Date.today

      owner = self.author

      if owner.is_admin? || owner.is_operator?
        s = Status.active
      elsif owner.is_agent?
        s = Status.suspended
      else
        s = Status.need_attention
      end

      self.status = s

    end

  end

end
