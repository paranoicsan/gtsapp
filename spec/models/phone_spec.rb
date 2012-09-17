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

    before(:each) do
      @phone = FactoryGirl.create :phone
    end

    it "первый телефон всегд имеет порядок отображения равный 1" do
      @phone.order_num.should eq(1)
    end
    it "каждый следующий телефон создаётся с повышенным индексом отображения" do
      new_phone = FactoryGirl.create :phone, branch_id: @phone.branch_id
      new_phone.order_num.should eq(2)
    end
    it "при создании телефона с указанным индексом, остальные индексы пресчитываются" do
      p2 = FactoryGirl.create :phone, branch_id: @phone.branch_id
      p3 = FactoryGirl.create :phone, branch_id: @phone.branch_id
      p4 = FactoryGirl.create :phone, branch_id: @phone.branch_id
      p5 = FactoryGirl.create :phone, branch_id: @phone.branch_id

      probe = FactoryGirl.create :phone, branch_id: @phone.branch_id, order_num: 3

      final_array = [@phone, p2, probe, p3, p4, p5]
      b_array = Branch.find(@phone.branch_id).phones_by_order

      #puts final_array.inspect
      puts b_array.inspect

      b_array.should eq(final_array)
    end

  end

end