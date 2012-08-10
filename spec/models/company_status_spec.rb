# encoding: utf-8
require 'spec_helper'

describe CompanyStatus do

  before(:all) do

    #@status_suspended = CompanyStatus.create name: 'На рассмотрении'
    #@status_archived = CompanyStatus.create name: 'В архиве'
  end

  describe "должен возвращать предопределённые объекты статуса" do

    # Метод создаёт в БД нужный объект
    def create_with_name(name)
      CompanyStatus.create name: name
    end

    it ".active возвращает объект активного статус" do
      s = create_with_name 'Активна'
      c = CompanyStatus.active
      c.should == s
    end
    it ".suspended возвращает объект статуса на рассмотрении" do
      s = create_with_name 'На рассмотрении'
      c = CompanyStatus.suspended
      c.should == s
    end
    it ".archived возвращает объект архивного статуса" do
      s = create_with_name 'В архиве'
      c = CompanyStatus.archived
      c.should == s
    end
  end

end
