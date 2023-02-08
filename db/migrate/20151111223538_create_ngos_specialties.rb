
class  CreateNgosSpecialties < ActiveRecord::Migration
  def change
    create_table(:ngos_specialties, :id => false) do |t|
   t.integer :organization_id
   t.integer :specialty_id
    end
execute "ALTER TABLE ngos_specialties ADD PRIMARY KEY (organization_id,specialty_id);"
  end
end



