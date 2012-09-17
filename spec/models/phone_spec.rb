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

  describe "обработка порядка отображения" do

    it "первый телефон всегд имеет порядок отображения равный 1" do
      phone = FactoryGirl.create :phone
      phone.order_num.should eq(1)
    end
    it "каждый следующий телефон создаётся с повышенным индексом отображения" do
      phone_origin = FactoryGirl.create :phone
      phone = FactoryGirl.create :phone, branch_id: phone_origin.branch_id
      phone.order_num.should eq(2)
    end

  end

end