# Encoding: utf-8
require 'spec_helper'

describe Branch do

  let(:branch) { FactoryGirl.create :branch }

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

  it "нельзя создать без фактического названия" do
    branch = FactoryGirl.build :branch, fact_name: ''
    branch.should have(1).error_on(:fact_name)
  end
  it "нельзя создать без юридического названия" do
    branch = FactoryGirl.build :branch, legel_name: ''
    branch.should have(1).error_on(:legel_name)
  end

end