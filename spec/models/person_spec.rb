# Encoding: utf-8
require 'spec_helper'

describe Person do

  it "Фабрика корректна" do
    FactoryGirl.create(:person).should be_valid
  end

  it "не может быть создана без имени" do
    person = FactoryGirl.build :person, name: nil
    person.should have(1).error_on(:name)
  end

  it "не может быть создана без фамилии" do
    person = FactoryGirl.build :person, second_name: nil
    person.should have(1).error_on(:second_name)
  end

  it "не может быть создана с символами в телефоне" do
    person = FactoryGirl.build :person, phone: '32wewe232'
    person.should have(1).error_on(:phone)
  end

  it "не может быть создана с некорректным email" do
    person = FactoryGirl.build :person, email: '32wewe232'
    person.should have(1).error_on(:email)
  end

  describe ".full_name" do
    it "возвращает полное имя через пробелы" do
      person = FactoryGirl.create :person
      person.full_name.should eq("#{person.second_name} #{person.name} #{person.middle_name}")
    end
  end

end
