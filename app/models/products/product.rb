class Products::Product < ActiveRecord::Base

  belongs_to :type
  belongs_to :contract, class_name: 'Contracts::Contract'
  belongs_to :rubric

  validates_presence_of :type,
                        :contract

end
