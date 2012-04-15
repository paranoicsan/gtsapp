class Branch < ActiveRecord::Base
  has_one :address
  belongs_to :form_type
  belongs_to :company
end
