# encoding: utf-8
require 'spec_helper'

describe Rubric do

  it "фабрика корректна" do
    rubric = FactoryGirl.create :rubric
    rubric.should be_valid
  end
  it "не может быть создана без названия" do
    rubric = FactoryGirl.build :rubric, name: nil
    rubric.should have(1).error_on(:name)
  end
  it "не может быть создан дубликат рубрики по имени" do
    s = Faker::Lorem.words.join
    FactoryGirl.create :rubric, name: s
    rubric = FactoryGirl.build :rubric, name: s
    rubric.should have(1).error_on(:name)
  end

  describe ".by_rubricator" do
    before(:all) do
      r1 = Rubric.create name: 'rub_1', social: true
      r2 = Rubric.create name: 'rub_2', social: true
      r3 = Rubric.create name: 'rub_3', social: false
      r4 = Rubric.create name: 'rub_4', social: false
      r5 = Rubric.create name: 'rub_5', social: true

      @all = [r1, r2, r3, r4, r5]
      @social = [r1, r2, r5]
      @commercial = [r3, r4]

    end

    it "возвращает все социальные для рубрикатора - 1" do
      rubs = Rubric.by_rubricator 1
      assert rubs.count == @social.count, "Количество рубрик не совпадает!"
      rubs.each_with_index do |rub, i|
        assert rub.name == @social[i].name
      end
    end
    it "возвращает все коммерческие для рубрикатора - 2" do
      rubs = Rubric.by_rubricator 2
      assert rubs.count == @commercial.count, "Количество рубрик не совпадает!"
      rubs.each_with_index do |rub, i|
        assert rub.name == @commercial[i].name
      end
    end
    it "возвращает абсолютно все для рубрикатора - 3" do
      rubs = Rubric.by_rubricator 3
      assert rubs.count == @all.count, "Количество рубрик не совпадает!"
      rubs.each_with_index do |rub, i|
        assert rub.name == @all[i].name
      end
    end
  end

  describe ".rubricator_name_for" do
    it "возвращает название социального" do
      Rubric.rubricator_name_for(1).should eq("Социальный")
    end
    it "возвращает название полного" do
      Rubric.rubricator_name_for(3).should eq("Полный")
    end
    it "возвращает название коммерческого" do
      Rubric.rubricator_name_for(2).should eq("Коммерческий")
    end
  end
end
