class AddDistrictToCities < ActiveRecord::Migration
  def change

    add_column :cities, :mapbox_obj_id, :integer
 
  end
end
