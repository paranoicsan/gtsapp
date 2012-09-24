# encoding: utf-8
require 'spec_helper'

describe Street do

  before(:all) do
  end

  it "Фабрика корректна" do
    street = FactoryGirl.create :street
    street.should be_valid
  end
  it "не может быть создана без названия" do
    street = FactoryGirl.build :street, name: nil
    street.should have(1).error_on(:name)
  end
  it "не может быть создана без города" do
    street = FactoryGirl.build :street, city_id: nil
    street.should have(1).error_on(:city_id)
  end
  it "не может быть создан дубликат улицы в пределах города" do
    street = FactoryGirl.create :street
    new_street = FactoryGirl.build :street, name: street.name.downcase, city_id: street.city_id
    puts new_street.name
    puts street.name
    new_street.should have(1).error_on(:name)
  end
end
