class Branch < ActiveRecord::Base
  belongs_to :address
  belongs_to :form_type
  belongs_to :company
end
