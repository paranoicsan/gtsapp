class AddNeedImprovementReason < ActiveRecord::Migration
  def change
    add_column :companies, :reason_need_improvement_on, :string
  end
end
