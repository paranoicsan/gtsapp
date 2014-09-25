require 'spec_helper'

describe Products::Product do

  it 'has valid factory' do
    FactoryGirl.create(:product).should be_valid
  end

  describe 'creation' do
    context 'it cannot be created without' do
      it 'type' do
        @params = { type: nil }
      end
      it 'contract' do
        @params = { contract: nil }
      end
      after(:each) do
        product = FactoryGirl.build :product, @params
        product.should_not be_valid
      end
    end
  end

end