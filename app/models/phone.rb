class Phone < ActiveRecord::Base
  belongs_to :branch
  validates_presence_of :name
  before_save :check_fields

  ##
  # Определяет самый низкий порядок отображения
  # @param [Integer] Ключ филиала, для которого ищем следующий индекс телефона
  # @return [Integer] Самый низкий порядок отображения
  def next_num_order(branch_id)
    # текущий последний телефон по отображению
    cur_last_phone = Phone.where("branch_id = ?", branch_id).order("order_num DESC").first
    cur_last_phone ? cur_last_phone.order_num + 1 : 1
  end

  private
  def check_fields
    # если это первоначальное создание телефона
    if order_num.nil?
      self.order_num = next_num_order(branch_id)
    else
      new_order = self.order_num
      # определяем по указанной позиции старый телефон
      old_phone = Phone.where("branch_id = ? and order_num = ?", branch_id, new_order).first
      unless old_phone.eql?(self) || old_phone.nil?
        old_phone.update_attribute "order_num", new_order + 1
        #next_phones = Phone.where("branch_id = ? and order_num > ?", branch_id, new_order)
        #next_phones.each do |p|
        #  unless p.id == old_phone.id
        #    cur_order = p.order_num
        #    p.update_attribute "order_num", cur_order + 1
        #  end
        #end
      end
    end
  end
end
