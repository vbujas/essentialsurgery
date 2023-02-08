class AddCountryToNgos < ActiveRecord::Migration
  def change

    add_column :ngos, :hq_city,  :string
    add_column :ngos, :hq_cntry_code,  "varchar(3)"   
 
  end
end
