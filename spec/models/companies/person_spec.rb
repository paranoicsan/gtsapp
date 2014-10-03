# == Schema Information
#
# Table name: companies_people
#
#  id          :integer          not null, primary key
#  position    :string(255)
#  name        :string(255)
#  second_name :string(255)
#  middle_name :string(255)
#  phone       :integer
#  email       :string(255)
#  company_id  :integer
#

require 'spec_helper'

describe Companies::Person do

  it 'Фабрика корректна' do
    FactoryGirl.create(:person).should be_valid
  end

  it 'не может быть создана без имени' do
    person = FactoryGirl.build :person, name: nil
    person.should have(1).error_on(:name)
  end

  it 'не может быть создана без фамилии' do
    person = FactoryGirl.build :person, second_name: nil
    person.should have(1).error_on(:second_name)
  end

  it 'не может быть создана с символами в телефоне' do
    person = FactoryGirl.build :person, phone: '32wewe232'
    person.should have(1).error_on(:phone)
  end

  it 'не может быть создана с некорректным email' do
    person = FactoryGirl.build :person, email: '32wewe232'
    person.should have(1).error_on(:email)
  end

  describe '#full_name' do
    it 'возвращает полное имя через пробелы' do
      person = FactoryGirl.create :person
      person.full_name.should eq("#{person.second_name} #{person.name} #{person.middle_name}")
    end
  end

  describe '#full_info' do
    it 'выводит все данные в строку через запятую' do
      person = FactoryGirl.create :person
      s = ''      
      s = s + %Q{#{person.position}, } if person.position
      s = s + %Q{#{person.full_name}, }
      s = s + %Q{#{person.phone}, } if person.phone
      s = s + %Q{#{person.email}, } if person.email
      s = s.gsub(/,$/, '')
      person.full_info.should eq(s)
    end
  end
  
end
