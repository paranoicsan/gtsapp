# encoding: utf-8
require 'spec_helper'

describe Company do

  it "Фабрика корректна" do
    #noinspection RubyResolve
    FactoryGirl.create(:company).should be_valid
  end

  it "компания не может быть создана без названия" do
    company = FactoryGirl.build(:company, title: nil)
    company.should have(1).error_on(:title)
    #noinspection RubyResolve
    company.should_not be_valid
  end

  describe "Показывает тот или иной рубрикатор в разном виде" do

    before(:each) do
      @company = FactoryGirl.create :company
    end

    context "должна возвращать отдельные виды рубрикатора" do

      it "возврат социального рубрикатора" do
        @company.rubricator = 1
        assert @company.social_rubricator?, "Должен быть только социальный рубрикатор"
      end
      it "возврат коммерческого рубрикатора" do
        @company.rubricator = 2
        assert @company.commercial_rubricator?, "Должен быть только коммерческий рубрикатор"
      end
      it "возврат полного рубрикатора" do
        @company.rubricator = 3
        assert @company.full_rubricator?, "Должен быть полный рубрикатор"
      end
    end

    context "возвращает текстовое название рубрикатора или рубрикаторов, связанных с компанией" do
      it "возврат имени социального рубрикатора" do
        @company.rubricator = 1
        assert @company.rubricator_name == "Социальный", "Социальный рубрикатор не выводится по имени"
      end
      it "возврат имени коммерческого рубрикатора" do
        @company.rubricator = 2
        assert @company.rubricator_name == "Коммерческий", "Коммерческий рубрикатор не выводится по имени"
      end
      it "возврат имени полного рубрикатора" do
        @company.rubricator = 3
        assert @company.rubricator_name == "Полный", "Полный рубрикатор не выводится по имени"
      end
    end

  end

  describe "Создаётся с тем или иным состоянием, в зависимости от прав автора" do
    pending "статус АКТИВНА, если создаёт админ или оператор" do

    end

    pending "статус НА РАССМОТРЕНИИ, если создаёт агент" do

    end

  end

end
