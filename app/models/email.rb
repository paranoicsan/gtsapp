class Email < ActiveRecord::Base
  belongs_to :branch
  validates_presence_of :name
end
