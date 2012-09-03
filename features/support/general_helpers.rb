# Encoding: utf-8
module GeneralHelpers

  TEXT_LINK_BACK_TO_SEARCH = "Назад к результатам поиска"

  ##
  #
  # Возвращает текущий путь
  #
  # @return [String] Путь, на котором сейчас находится дравйвер capybara
  def current_path
    URI.parse(current_url).path
  end

  def create_company_statuses
    ["Активна", "На рассмотрении", "В архиве", "На удалении", "Требует внимания", "Требует доработки"].each do |s|
      CompanyStatus.create(name: s).save! unless CompanyStatus.find_by_name(s)
    end
  end

  def create_company_sources
    ["Заявка с сайта", "От агента"].each do |s|
      CompanySource.create(name: s).save! unless CompanySource.find_by_name(s)
    end
  end

  def create_contract_statuses
    ["активен", "не активен", "на рассмотрении"].each do |s|
      ContractStatus.create(name: s).save! unless ContractStatus.find_by_name(s)
    end
  end

end

World(GeneralHelpers)