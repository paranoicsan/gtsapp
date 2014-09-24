class RenameContractStatusToStatus < ActiveRecord::Migration
  def change
    rename_table :contract_statuses, :contracts_statuses
  end
end
