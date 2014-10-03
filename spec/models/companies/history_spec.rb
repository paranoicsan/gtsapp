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

require 'spec_helper'

module Companies

  describe History do
    it 'фабрика корректна' do
      FactoryGirl.create(:company_history).should be_valid
    end
    describe '.log' do

      let(:company) { FactoryGirl.create :company }
      let(:operation) { Faker::Lorem.words(1).join }
      let(:user_id) { FactoryGirl.create(:user).id }

      def log
        History.log(operation, user_id, company.id)
      end

      it 'создаёт запись об операции' do
        expect {
          log
        }.to change(History, :count).by(1)
      end

      it 'сохраняет название операции' do
        log
        History.last.operation.should eq(operation)
      end

      it 'сохраняет пользователя' do
        log
        History.last.user_id.should eq(user_id)
      end

    end
  end

end
