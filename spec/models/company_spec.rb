# encoding: utf-8
require 'spec_helper'

describe Company do

  before(:each) do
    @company = Company.new
  end

  it "компания не может быть создана без названия" do
    @company.should have(1).error_on(:title)
    #noinspection RubyResolve
    @company.should_not be_valid
  end

  describe "должна возвращать отдельные виды рубрикатора" do
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
end
