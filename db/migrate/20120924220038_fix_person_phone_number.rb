class FixPersonPhoneNumber < ActiveRecord::Migration
  def change
    change_column :people, :phone, :integer, :limit => 8
  end
end
