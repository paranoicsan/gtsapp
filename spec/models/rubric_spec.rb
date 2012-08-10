# encoding: utf-8
require 'spec_helper'

describe Rubric do

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

  describe ".by_rubricator" do
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
end
