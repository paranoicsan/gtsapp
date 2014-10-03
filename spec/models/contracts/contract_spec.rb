# == Schema Information
#
# Table name: contracts_contracts
#
#  id                    :integer          not null, primary key
#  contracts_statuses_id :integer
#  contracts_codes_id    :integer
#  date_sign             :date
#  number                :string(255)
#  amount                :float
#  bonus                 :boolean
#  company_legel_name    :string(255)
#  person                :string(255)
#  company_details       :string(255)
#  number_of_dicts       :integer
#  company_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe Contracts::Contract do

  it 'фабрика корректна' do
    contract = FactoryGirl.create(:contract)
    contract.should be_valid
  end

  describe '#info' do
    it 'выводит указанную информацию в виде строки' do

      contract = FactoryGirl.create :contract

      # Типы продуктов
      prod_types = []
      2.times do
        product = FactoryGirl.create :product, contract: contract
        prod_types << product.type.name
      end

      sd = contract.date_sign.strftime('%d.%m.%Y')
      prods = ''
      prod_types.each do |pt|
        prods += "'#{pt}', "
      end

      s = %Q{№ #{contract.number}, #{contract.code.name}, заключён: #{sd}, #{prods}сумма: #{contract.amount}руб.}
      contract.info.should eq(s)
    end
    it 'не выводит код проекта, если он не указан' do
      contract = FactoryGirl.create :contract, code: nil
      sd = contract.date_sign.strftime('%d.%m.%Y')
      s = %Q{№ #{contract.number}, заключён: #{sd}, сумма: #{contract.amount}руб.}
      contract.info.should eq(s)
    end
    it 'не выводит дату заключения, если она есть' do
      contract = FactoryGirl.create :contract, date_sign: nil
      s = %Q{№ #{contract.number}, #{contract.code.name}, сумма: #{contract.amount}руб.}
      contract.info.should eq(s)
    end
  end

end
