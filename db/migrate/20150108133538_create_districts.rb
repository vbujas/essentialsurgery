class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string   :name
      t.integer  :mapbox_obj_id
      t.integer  :country_id
      t.integer  :est_population
      t.timestamps
    end
  end
end
