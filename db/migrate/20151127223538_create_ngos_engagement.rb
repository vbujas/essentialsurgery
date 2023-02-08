
class  CreateNgosEngagement < ActiveRecord::Migration
  def change
    create_table(:ngos_engagement, :id => false) do |t|
   t.integer :organization_id
   t.string :country_code, :limit => 3
    end
execute "ALTER TABLE ngos_engagement ADD PRIMARY KEY (organization_id, country_code);"
  end
end



