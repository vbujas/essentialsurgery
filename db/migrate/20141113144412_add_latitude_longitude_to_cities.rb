class AddLatitudeLongitudeToCities < ActiveRecord::Migration
  def change
    add_column :cities, :latitude, :string
    add_column :cities, :longitude, :string
  end
end
