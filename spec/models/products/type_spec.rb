require 'spec_helper'

describe Products::Type do

  it 'has valid factory' do
    FactoryGirl.create(:product_type).should be_valid
  end

  describe 'creation' do
    context 'it cannot be created without' do
      it 'name' do
        type = FactoryGirl.build :product_type, name: nil
        type.should_not be_valid
      end
    end
  end


end
