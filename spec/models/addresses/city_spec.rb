require 'spec_helper'

module Addresses

  describe City do

    it 'has valid factory' do
      city = FactoryGirl.create :city
      city.should be_valid
    end

    context 'cannot be created without' do
      it 'name' do
        @params = {name: nil}
      end
      it 'code' do
        @params = {name: nil}
      end
      after(:each) do
        city = FactoryGirl.build :city, @params
        city.should_not be_valid
      end
    end

  end

end