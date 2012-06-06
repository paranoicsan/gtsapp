class Contract < ActiveRecord::Base
  belongs_to :company
  belongs_to :contract_status
  belongs_to :project_code
end
