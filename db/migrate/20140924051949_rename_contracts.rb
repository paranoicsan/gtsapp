class RenameContracts < ActiveRecord::Migration
  def change
    rename_table :contracts, :contracts_contracts
    rename_column :contracts_contracts, :contract_status_id, :contracts_statuses_id
    rename_column :contracts_contracts, :project_code_id, :contracts_codes_id
  end
end
