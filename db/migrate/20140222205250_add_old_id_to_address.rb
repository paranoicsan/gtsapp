class AddOldIdToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :old_id, :integer
  end
end
