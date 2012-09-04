class CompanyHistory < ActiveRecord::Base
  belongs_to :company

  ##
  # Создаёт запись об операции
  # @param [String] operation Описание операции
  # @param [String] username имя пользователя
  # @param [Integer] id ключ компании
  def self.log(operation, username, id)
    self.new(:operation => operation, :username => username, :company_id => id).save
  end

end
