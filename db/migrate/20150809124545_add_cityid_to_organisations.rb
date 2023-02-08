class AddCityidToOrganisations < ActiveRecord::Migration
  def change

    add_column :organisations, :city_id, :integer
    

  end
end
