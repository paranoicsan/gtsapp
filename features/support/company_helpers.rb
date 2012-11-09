# encoding: utf-8
module CompanyHelpers

  ##
  #
  # Ищет филиал по имени его и компании
  #
  # @param [String] bname Имя филиала
  # @param [String] cname Имя компании
  # @return [Branch]
  #noinspection RubyResolve
  def find_branch(bname, cname)
    company = Company.find_by_title cname
    company.branches.find_by_fact_name bname
  end

  ##
  #
  # Создает объект телефона с указанными параметрами
  #
  # @param [Hash] params Набор параметров
  # @return [Phone] Объект телефона
  def create_phone(params)
    phone = Phone.create! params
    phone.save
    phone
  end

  ##
  #
  # Формирует массив с информацией о филиалах, для проверки
  # их табличного представленния на странице компании
  #
  # @param [Company] company Объект компании
  # @return [Array] Массив с инфромацией
  def branch_populate_rows(company)
    rows = []
    # Головной(без заголовка)
    # Форма собственности
    # Фактическое название
    # Юридическое название
    # Адрес
    # Удалить(без заголовка)
    company.branches.each do |branch|
      #noinspection RubyResolve
      row = [
        branch.is_main? ? "Головной филиал" : "",
        branch.form_type.name,
        branch.fact_name,
        branch.legel_name,
        branch.address ? branch.address.full_address : "",
        "Удалить"
      ]
      rows << row
    end
    rows
  end

  ##
  # Создаёт компанию при помощи фабрики
  # @return [Company] Созданный экземпляр компании
  def create_company(active=false)
    if active
      FactoryGirl.create :company, company_status_id: CompanyStatus.active.id
    else
      FactoryGirl.create :company
    end
  end

  ##
  # Создаёт компанию при помощи фабрики c указанным статусом
  # @return [Company] Созданный экземпляр компании
  def create_company_wstatus(status)
    company = FactoryGirl.create :company, company_status_id: status.id
    2.times { FactoryGirl.create :branch, company_id: company.id }
  end

  ##
  # Создаёт несколько записей в истории для указанного агента
  # @param [User] Агент, для которого делаются записи
  def create_history(agent)
    company_1 = FactoryGirl.create :company, author_user_id: agent.id
    CompanyHistory.log("создал компанию", agent.id, company_1.id)
    CompanyHistory.log("обновил компанию", agent.id, company_1.id)
    company_2 = FactoryGirl.create :company
    CompanyHistory.log("добавил рубрику", agent.id, company_2.id)
  end



end

World(CompanyHelpers)