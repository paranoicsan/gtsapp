class Branches::Branch < ActiveRecord::Base

  has_one :address, dependent: :destroy, class_name: 'Addresses::Address'
  has_many :phones, dependent: :destroy
  has_many :emails, dependent: :destroy
  has_and_belongs_to_many :websites, join_table: 'branches_websites_join'

  validates_presence_of :fact_name, message: 'Укажите фактическое название'
  validates_presence_of :legel_name, message: 'Укажите юридическое название'

  belongs_to :form_type
  belongs_to :company, class_name: 'Companies::Company'

  before_save :check_is_main

  scope :by_company, ->(id){ where(company_id: id) }

  ##
  # Устанавливает филиал как основной
  # и снимает этот флаг со всех остальных филиалов
  def make_main
    c_id = company_id
    Branches::Branch.where(company_id: c_id).each do |b|
      val = b.id == self.id
      b.update_attributes is_main: val
    end
  end

  ##
  # Возвращает полное название филиала
  # @return {String} Отформатированное название
  def formatted_name
    res = ''
    params = {
      ft: form_type ? form_type.name : '',
      fn: fact_name? ? fact_name : '',
      ln: legel_name? ? legel_name : '',
    }
    params.each_value do |p|
      res = res + p + ' ' if p.length > 0
    end
    res.strip
  end

  ##
  # Вовзращаетв все адреса в строку через запятую
  def all_emails_str
    s = ''
    emails.each {|e| s = "#{s}#{e.name}, "}
    s.gsub /, $/, ''
  end

  ##
  # Вовзращаетв все адреса веб-сайтов в строку через запятую
  def all_websites_str
    s = ''
    websites.each {|w| s = "#{s}#{w.name}, "}
    s.gsub /, $/, ''
  end

  ##
  # Возвращает масив телефонов по индексу отображения
  def phones_by_order
    phones.order 'order_num ASC'
  end

  ##
  # Определяет следующий порядок отображения для телефонов филиала
  # @return [Integer] Самый низкий порядок отображения
  def next_phone_order_index
    last_order = phones_by_order.last.try(:order_num).to_i
    last_order + 1
  end

  ##
  # Пересчитывает индексы для телефонов
  # если происходило изменение индекса существовавшего ранее телефона,
  # то это определяется временем изменений
  # @param [Boolea] creation - флаг, что обновить порядок надо после создания нового телефона
  def update_phone_order(creation=false)
    idx = 1
    direction = creation ? 'DESC' : 'ASC'
    phones_by_order.order("updated_at #{direction}").each do |p|
      p.update_attribute 'order_num', idx
      idx += 1
    end
  end

  private
  ##
  # Обработка флага, что филиал является головным,
  # если он является единственным
  def check_is_main
    if self.new_record?
      count = Branches::Branch.find_all_by_company_id(self.company_id).count
      self.is_main = count.zero?
    end
    true
  end

end

