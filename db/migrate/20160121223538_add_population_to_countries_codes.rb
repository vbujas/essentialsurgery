
class  AddPopulationToCountriesCodes < ActiveRecord::Migration
    def change

    add_column :countries_codes, :population, :integer
    

  end
end



