# == Schema Information
#
# Table name: products_types
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  size_width    :float
#  size_height   :float
#  bonus_type_id :integer
#  bonus_site    :string(255)
#  price         :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_products_types_on_id  (id)
#

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
