# == Schema Information
#
# Table name: products_products
#
#  id          :integer          not null, primary key
#  contract_id :integer
#  type_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  rubric_id   :integer
#  proposal    :text
#
# Indexes
#
#  index_products_products_on_id  (id)
#

class Products::Product < ActiveRecord::Base

  belongs_to :type
  belongs_to :contract, class_name: 'Contracts::Contract'
  belongs_to :rubric, class_name: 'Rubrics::Rubric'

  validates_presence_of :type,
                        :contract

end
