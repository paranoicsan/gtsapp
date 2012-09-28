# encoding: utf-8
require 'spec_helper'

describe Contract do

  it "фабрика корректна" do
    FactoryGirl.create(:contract).should be_valid
  end

  describe "#info" do
    it "выводит указанную информацию в виде строки" do
      code = FactoryGirl.create :project_code
      contract = FactoryGirl.create :contract, project_code_id: code.id
      s = %Q{#{contract.number}, #{code.name}, #{contract.amount}}
      contract.info.should eq(s)
    end
    it "не выводит код проекта, если он не указан" do
      contract = FactoryGirl.create :contract, project_code: nil
      s = %Q{#{contract.number}, #{contract.amount}}
      contract.info.should eq(s)
    end
  end

end