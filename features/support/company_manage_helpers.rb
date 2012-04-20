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

end

World(CompanyManageHelpers)