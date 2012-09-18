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
end