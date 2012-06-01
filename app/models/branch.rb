class Branch < ActiveRecord::Base
  has_one :address
  has_many :phones
  has_many :branch_websites
  has_many :websites, :through => :branch_websites
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

  ##
  #
  # Устанавливает филиал как основной
  # и снимает этот флаг со всех остальных филиалов
  #
  def make_main
    c_id = self.company_id
    Branch.find_all_by_company_id(c_id).each do |b|
      b.is_main? = b.eql?(self)
      b.save
    end
  end
end
