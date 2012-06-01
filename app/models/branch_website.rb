class BranchWebsite < ActiveRecord::Base
  belongs_to :branch
  belongs_to :website
end
