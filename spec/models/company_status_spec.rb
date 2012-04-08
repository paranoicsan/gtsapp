# encoding: utf-8
require 'spec_helper'

describe CompanyStatus do

  before(:each) do
    @company_status = CompanyStatus.new
  end

  describe "должен возвращать предопределённые объекты статуса" do
    it "Активный статус" do
      @company_status.name = "Активна"
      @company_status.save
      assert CompanyStatus.active == @company_status, "Активный статус не возвращается"
    end
    it "На рассмотрении" do
      @company_status.name = "На рассмотрении"
      @company_status.save
      assert CompanyStatus.pending == @company_status, "Статус на рассмотрении не возвращается"
    end
    it "Архивный статус" do
      @company_status.name = "В архиве"
      @company_status.save
      assert CompanyStatus.archived == @company_status, "Архивный статус не возвращается"
    end
  end

end
