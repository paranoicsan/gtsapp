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

end