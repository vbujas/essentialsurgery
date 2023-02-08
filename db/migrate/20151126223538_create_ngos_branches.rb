
class  CreateNgosBranches < ActiveRecord::Migration
  def change
    create_table(:ngos_branches, :id => false) do |t|
   t.integer :organization_id
   t.string :country_code, :limit => 3
    end
execute "ALTER TABLE ngos_branches ADD PRIMARY KEY (organization_id, country_code);"
  end
end



