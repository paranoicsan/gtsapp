class Branch < ActiveRecord::Base
  has_one :address
  has_many :phones
  belongs_to :form_type
  belongs_to :company
  before_save :check_is_main

  ##
  #
  # Обработка флага, что филиал является головным,
  # если он является единственным
  #
  def check_is_main
    if Branch.find_all_by_company_id(self.company_id).count == 0
      self.is_main = true
    end
  end
end
