# encoding: utf-8
# == Schema Information
#
# Table name: companies_statuses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Companies::Status < ActiveRecord::Base
  has_many :companies

  ##
  # Активный
  def self.active
    self.find_by_name 'Активна'
  end

  ##
  # На рассмотрении
  def self.suspended
    self.find_by_name 'На рассмотрении'
  end

  ##
  # В архиве
  def self.archived
    self.find_by_name 'В архиве'
  end

  ##
  # На удалении
  def self.queued_for_delete
    self.find_by_name 'На удалении'
  end

  ##
  # Требует внимания
  def self.need_attention
    self.find_by_name 'Требует внимания'
  end

  ##
  # Требует доработки
  def self.need_improvement
    self.find_by_name 'Требует доработки'
  end

  ##
  # Повторное рассмотрение
  def self.second_suspend
    self.find_by_name 'Повторное рассмотрение'
  end

end
