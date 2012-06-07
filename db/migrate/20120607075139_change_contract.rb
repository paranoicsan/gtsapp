class ChangeContract < ActiveRecord::Migration
  def change
    change_column :contracts, :amount, :float
  end
end
