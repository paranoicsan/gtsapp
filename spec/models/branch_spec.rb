# Encoding: utf-8
require 'spec_helper'

describe Branch do

  let(:branch) { FactoryGirl.create :branch }

  it "фабрика корректна" do
    b = FactoryGirl.create :branch
    b.should be_valid
  end
  it "нельзя создать без фактического названия" do
    branch = FactoryGirl.build :branch, fact_name: ''
    branch.should have(1).error_on(:fact_name)
  end
  it "нельзя создать без юридического названия" do
    branch = FactoryGirl.build :branch, legel_name: ''
    branch.should have(1).error_on(:legel_name)
  end

  describe "#all_emails_str" do
    it "возвращает все адреса через запятую" do
      3.times do
        branch.emails << FactoryGirl.create(:email, branch_id: branch.id)
      end
      s = ""
      branch.emails.each {|e| s = "#{s}#{e.name}, "}
      s = s.gsub(/, $/, "")
      branch.all_emails_str.should eq(s)
    end
  end

  describe "#all_websites_str" do
    it "возвращает все сайты через запятую" do
      3.times do
        branch.websites << FactoryGirl.create(:website)
      end
      s = ""
      branch.websites.each {|w| s = "#{s}#{w.name}, "}
      s = s.gsub(/, $/, "")
      branch.all_websites_str.should eq(s)
    end
  end

  describe "#phones_by_order" do
    def create_phone(branch_id)
      FactoryGirl.create :phone, branch_id: branch_id
    end
    it "возвращает массив по порядку индекса отображения" do
      branch = FactoryGirl.create :branch
      p1 = create_phone(branch.id)
      p2 = create_phone(branch.id)
      branch.phones_by_order.should eq([p1, p2])
    end
  end

  describe "#next_phone_order_index" do
    it "возвращает единицу для первого телефона" do
      branch.next_phone_order_index.should eq(1)
    end
    it "возвращает следующий порядковый индекс отображения для телефонов" do
      FactoryGirl.create :phone, branch_id: branch.id
      branch.next_phone_order_index.should eq(2)
    end
  end

  describe "#update_phone_order" do
    PHONE_CNT = 5
    before(:each) do
      PHONE_CNT.times do |i|
        FactoryGirl.create :phone, branch_id: branch.id, order_num: i+1
      end
    end
    def delete_and_update(index)
      branch.phones[index].destroy
      branch.phones.reload
      branch.update_phone_order
      branch.reload
    end

    it "обновляет список телефонов при удалении первого" do
      delete_and_update(0)
      branch.phones[0].order_num.should eq(1)
    end
    it "обновляет список телефонов при удалении из середины" do
      delete_and_update(PHONE_CNT-3)
      branch.phones.count.times do |i|
        branch.phones[i].order_num.should eq(i+1)
      end
    end
    it "ничего не меняется при удалении последнего" do
      delete_and_update(PHONE_CNT-1)
      branch.phones[PHONE_CNT-2].order_num.should eq(PHONE_CNT-1)
    end
    it "обновляет список телефонов при добавлении нового" do
      FactoryGirl.create :phone, branch_id: branch.id, order_num: 3
      branch.update_phone_order(true)
      branch.reload
      branch.phones.count.times do |i|
        branch.phones[i].order_num.should eq(i+1)
      end
    end
    it "обновляет список телефонов при изменении существующего" do
      moved_phone = branch.phones[3]
      branch.phones[1].update_attribute "order_num", 4
      branch.update_phone_order
      moved_phone.reload
      moved_phone.order_num.should eq(3)
    end
  end
end