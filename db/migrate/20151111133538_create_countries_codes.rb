class CreateCountriesCodes < ActiveRecord::Migration
  def change
    create_table(:countries_codes , id: false, :primary_key => 'country_code' ) do |t|
      t.string   :country_code, :limit => 3
      t.string   :country_name
      t.timestamps
    end
  end
end
