class CompanyHistory < ActiveRecord::Base
  belongs_to :company
  belongs_to :user

  ##
  # Создаёт запись об операции
  # @param [String] operation Описание операции
  # @param [Integer] user_id ключ пользователя
  # @param [Integer] id ключ компании
  def self.log(operation, user_id, id)
    self.new(:operation => operation, :user_id => user_id, :company_id => id).save
  end

end
