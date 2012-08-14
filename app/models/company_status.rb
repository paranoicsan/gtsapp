# encoding: utf-8
class CompanyStatus < ActiveRecord::Base
  has_many :companies

  def self.active
    self.find_by_name "Активна"
  end

  def self.suspended
    self.find_by_name "На рассмотрении"
  end

  def self.archived
    self.find_by_name "В архиве"
  end

  def self.on_deletion
    self.find_by_name "На удалении"
  end

end
