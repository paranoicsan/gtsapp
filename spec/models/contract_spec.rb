# encoding: utf-8
require 'spec_helper'

describe Contract do

  it "фабрика корректна" do
    FactoryGirl.create(:contract).should be_valid
  end

  describe "#info" do
    it "выводит указанную информацию в виде строки" do

      code = FactoryGirl.create :project_code # Код проекта
      contract = FactoryGirl.create :contract, project_code_id: code.id, date_sign: Date.today

      # Типы продуктов
      prod_types = []
      2.times { prod_types << FactoryGirl.create(:product, contract_id: contract.id).product_type.name }

      sd = contract.date_sign.strftime("%d.%m.%Y")
      prods = ""
      prod_types.each do |pt|
        prods =%Q{#{prods}"#{pt}", }
      end

        s = %Q{№ #{contract.number}, #{code.name}, заключён: #{sd}, #{prods}сумма: #{contract.amount}руб.}
      contract.info.should eq(s)
    end
    it "не выводит код проекта, если он не указан" do
      contract = FactoryGirl.create :contract, project_code: nil
      s = %Q{№ #{contract.number}, сумма: #{contract.amount}руб.}
      contract.info.should eq(s)
    end
    it "не выводит дату заключения, если она есть" do
      contract = FactoryGirl.create :contract
      s = %Q{№ #{contract.number}, #{contract.project_code.name}, сумма: #{contract.amount}руб.}
      contract.info.should eq(s)
    end
  end

end