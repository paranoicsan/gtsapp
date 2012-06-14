# encoding: utf-8
class Contract < ActiveRecord::Base
  belongs_to :company
  belongs_to :contract_status
  belongs_to :project_code
  validates_presence_of :number, :message => "Введите номер договора!"
  validates :number, :uniqueness => {:case_sensitive => false, message: "Договор с таким номером уже существует!"}

  ##
  # Позволяет определить, может ли указанный пользоваитель удалить договор
  # @param [User] Пользователь
  # @return [Boolean] Истина, когда пользователь может удалить договор
  #
  #noinspection RubyResolve
  def can_delete?(user)
    if user.is_admin?
      true
    elsif user.is_operator?
      self.contract_status == ContractStatus.active
    else
      false
    end
  end
end
