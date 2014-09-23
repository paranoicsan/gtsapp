class RenamePersonToCompaniesPerson < ActiveRecord::Migration
    def change
      rename_table :people, :companies_people
    end
end
