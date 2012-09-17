class Phone < ActiveRecord::Base
  belongs_to :branch
  validates_presence_of :name
  before_save :check_fields

  ##
  # Определяет самый низкий порядок отображения
  # @return [Integer] Самый низкий порядок отображения
  def next_num_order
    # текущий последний телефон по отображению
    cur_last_phone = Phone.where("branch_id = ?", [branch_id]).order("order_num DESC").first
    cur_last_phone ? cur_last_phone.order_num + 1 : 1
  end

  private
  def check_fields
    if order_num.nil?
      self.order_num = next_num_order
    end
  end
end
