# encoding: utf-8
class CompanySource < ActiveRecord::Base
  has_many :companies

  ##
  # Определяет ключ источника "От агента"
  #
  # @return [Integer] Ключ источника с именем "От агента"
  #
  def self.from_agent_id
    obj = CompanySource.find_by_name('От агента')
    if obj
      obj.id
    end
  end

end
