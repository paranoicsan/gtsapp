class RenameProjectCodeToCode < ActiveRecord::Migration
  def change
    rename_table :project_codes, :contracts_codes
  end
end
