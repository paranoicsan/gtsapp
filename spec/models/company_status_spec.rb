# encoding: utf-8
require 'spec_helper'

describe CompanyStatus do

  describe "должен возвращать предопределённые объекты статуса" do
    it "Активный статус" do
      assert CompanyStatus.active.name == "Активна", "Активный статус не возвращается"
    end
    it "На рассмотрении" do
      assert CompanyStatus.suspended.name == "На рассмотрении", "Статус на рассмотрении не возвращается"
    end
    it "Архивный статус" do
      assert CompanyStatus.archived.name == "В архиве", "Архивный статус не возвращается"
    end
  end

end
