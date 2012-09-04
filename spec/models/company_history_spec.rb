# Encoding: utf-8
require 'spec_helper'

describe CompanyHistory do
  it "фабрика корректна" do
    FactoryGirl.create(:company_history).should be_valid
  end
  describe ".log" do

    let(:company) { FactoryGirl.create :company }
    let(:operation) { Faker::Lorem.words(1).join }
    let(:username) { Faker::Internet.user_name }

    def log
      CompanyHistory.log(operation, username, company.id)
    end

    it "создаёт запись об операции" do
      expect {
        log
      }.to change(CompanyHistory, :count).by(1)
    end

    it "сохраняет название операции" do
      log
      CompanyHistory.last.operation.should eq(operation)
    end

    it "сохраняет имя пользователя" do
      log
      CompanyHistory.last.username.should eq(username)
    end

  end
end
