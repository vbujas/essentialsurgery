class CreateCountriesStatsNew < ActiveRecord::Migration
  def change
    create_table(:countries_stats , id: false, :primary_key => 'country_code' ) do |t|
      t.string   :country_code
      t.string  :income
      t.integer  :population
      t.integer  :surgeons
      t.integer  :obstetricians
      t.integer  :anesthesiologists
      t.timestamps 
    end
  end
end
