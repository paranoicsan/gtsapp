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
        prod_types << product.product_type.name
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