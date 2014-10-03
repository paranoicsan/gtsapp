# encoding: utf-8
# == Schema Information
#
# Table name: companies_sources
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Companies::Source < ActiveRecord::Base
  has_many :companies

  ##
  # Определяет ключ источника "От агента"
  #
  # @return [Integer] Ключ источника с именем "От агента"
  #
  def self.from_agent_id
    obj = Source.find_by_name('От агента')
    if obj
      obj.id
    end
  end

end
