# == Schema Information
#
# Table name: branches_emails
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  branch_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_branches_emails_on_id  (id)
#

class Branches::Email < ActiveRecord::Base
  belongs_to :branch

  validates_presence_of :name

  ##
  # Проверяет корректность
  #
  # @param [String] email Переданный на проверку адрес
  # @return [Boolean] Истина - адрес корректен
  def self.valid?(email)
    re = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
    re.match(email) ? true : false
  end

end
