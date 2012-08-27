class Branch < ActiveRecord::Base
  has_one :address, :dependent => :destroy
  has_many :phones, :dependent => :destroy
  has_many :branch_websites, :dependent => :destroy
  has_many :websites, :through => :branch_websites, :dependent => :destroy
  has_many :emails, :dependent => :destroy
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
      #noinspection RubyResolve
      b.is_main = b.eql?(self)
      b.save
    end
  end

  ##
  # Возвращает полное название филиала
  # @return {String} Отформатированное название
  def formatted_name
    res = ''
    params = {
      ft: self.form_type ? self.form_type.name : '',
      fn: self.fact_name? ? self.fact_name : '',
      ln: self.legel_name? ? self.legel_name : '',
    }
    params.each_value do |p|
      res = res + p + ' ' if p.length > 0
    end
    res.strip
  end

  ##
  # Вовзращаетв все адреса в строку через запятую
  def all_emails_str
    s = ""
    emails.each {|e| s = "#{s}#{e.name}, "}
    s.gsub(/, $/, "")
  end
end
