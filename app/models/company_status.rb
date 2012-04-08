# encoding: utf-8
class CompanyStatus < ActiveRecord::Base
  has_many :companies

  def self.active
    CompanyStatus.find_by_name "Активна"
  end

  def self.pending
    CompanyStatus.find_by_name "На рассмотрении"
  end

  def self.archived
    CompanyStatus.find_by_name "В архиве"
  end

end
