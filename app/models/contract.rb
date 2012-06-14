# encoding: utf-8
class Contract < ActiveRecord::Base
  belongs_to :company
  belongs_to :contract_status
  belongs_to :project_code
  validates_presence_of :number, :message => "Введите номер договора!"
  validates :number, :uniqueness => {:case_sensitive => false, message: "Договор с таким номером уже существует!"}
end
