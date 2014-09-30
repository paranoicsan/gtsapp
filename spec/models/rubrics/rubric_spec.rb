require 'spec_helper'

describe Rubrics::Rubric do

  it 'фабрика корректна' do
    rubric = FactoryGirl.create :rubric
    rubric.should be_valid
  end
  it 'не может быть создана без названия' do
    rubric = FactoryGirl.build :rubric, name: nil
    rubric.should have(1).error_on(:name)
  end
  it 'не может быть создан дубликат рубрики по имени' do
    s = Faker::Lorem.words.join
    FactoryGirl.create :rubric, name: s
    rubric = FactoryGirl.build :rubric, name: s
    rubric.should have(1).error_on(:name)
  end

  describe '.by_rubricator' do
    before(:each) do

      r1 = FactoryGirl.create :rubric, name: 'rub_1'
      r2 = FactoryGirl.create :rubric, name: 'rub_2'
      r3 = FactoryGirl.create :rubric_comercial, name: 'rub_3'
      r4 = FactoryGirl.create :rubric_comercial, name: 'rub_4'
      r5 = FactoryGirl.create :rubric, name: 'rub_5'

      @all = [r1, r2, r3, r4, r5]
      @social = [r1, r2, r5]
      @commercial = [r3, r4]

    end

    it 'возвращает все социальные для рубрикатора - 1' do
      rubs = Rubrics::Rubric.by_rubricator 1
      rubs.count.should == @social.count
      rubs.each_with_index do |rub, i|
        rub.name.should eq(@social[i].name)
      end
    end
    it 'возвращает все коммерческие для рубрикатора - 2' do
      rubs = Rubrics::Rubric.by_rubricator 2
      assert rubs.count == @commercial.count, 'Количество рубрик не совпадает!'
      rubs.each_with_index do |rub, i|
        assert rub.name == @commercial[i].name
      end
    end
    it 'возвращает абсолютно все для рубрикатора - 3' do
      rubs = Rubrics::Rubric.by_rubricator 3
      assert rubs.count == @all.count, 'Количество рубрик не совпадает!'
      rubs.each_with_index do |rub, i|
        assert rub.name == @all[i].name
      end
    end
  end

  describe '.rubricator_name_for' do
    context 'returns specific rubricator name' do
      it do
        types = Rubrics::Rubric::RUBRICATOR_TYPE
        types.each_with_index do |type, i|
          Rubrics::Rubric.rubricator_name_for(i - 1).should eq(type)
        end
      end
    end
    it 'returns nil if requested rubricator does not exist' do
      Rubrics::Rubric.rubricator_name_for(-100).should be_nil
    end
  end
end
