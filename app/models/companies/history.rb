# == Schema Information
#
# Table name: companies_histories
#
#  id         :integer          not null, primary key
#  operation  :text
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Companies::History < ActiveRecord::Base
  belongs_to :company
  belongs_to :user, class_name: 'Users::User'

  scope :by_user, lambda { |user_id| where( user_id: user_id ) }
  scope :uniq_company_ids, select: 'DISTINCT company_id'

  ##
  # Создаёт запись об операции
  #
  # @param [String] operation Описание операции
  # @param [Integer] user_id ключ пользователя
  # @param [Integer] id ключ компании
  #
  def self.log(operation, user_id, id)
    params = {
        operation: operation,
        user_id: user_id,
        company_id: id
    }
    self.new(params).save
  end

end
