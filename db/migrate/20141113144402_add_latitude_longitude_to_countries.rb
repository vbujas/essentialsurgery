class AddLatitudeLongitudeToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :latitude, :string
    add_column :countries, :longitude, :string
  end
end
