# encoding: utf-8
module CompanyManageHelpers

  ##
  #
  # Ищет филиал по имени его и компании
  #
  # @param [String] bname Имя филиала
  # @param [String] cname Имя компании
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

end

World(CompanyManageHelpers)