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

describe Branches::Email do

  describe 'существует проверка на корректность введённого адреса' do
    it 'возвращает истину при корректном адресе' do
      s = 'test@test.com'
      Branches::Email.valid?(s).should be_true
    end
    it 'возвращает ложь при ошибочном адресе' do
      emails = %w( test@test testtest.com testtest)
      emails.each do |email|
        Branches::Email.valid?(email).should be_false
      end
    end
  end

end
