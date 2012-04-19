class Branch < ActiveRecord::Base
  has_one :address
  has_many :phones
  belongs_to :form_type
  belongs_to :company
end
