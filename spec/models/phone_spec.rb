#Encoding: utf-8
require "spec_helper"

describe Phone do

  it "фабрика корректна" do
    phone = FactoryGirl.create :phone
    phone.should be_valid
  end
  it "нельзя создать без указания номера" do
    phone = FactoryGirl.build :phone, name: nil
    phone.should have(1).error_on(:name)
  end
  describe "#name_formatted" do
    it "возвращает простой номер без изменений для обычного телефона" do
      phone = FactoryGirl.create :phone
      phone.name_formatted.should eq(phone.name)
    end
    it "возвращает префикс с номером для мобильных номеров" do
      phone = FactoryGirl.create :phone, mobile: true, mobile_refix: '921'
      s = %Q{(921) #{phone.name}}
      phone.name_formatted.should eq(s)
    end
  end
end