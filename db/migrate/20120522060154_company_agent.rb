class CompanyAgent < ActiveRecord::Migration
  def change
    add_column :companies, :agent_id, :integer
    add_foreign_key :companies, :users, :column => 'agent_id'
  end
end
