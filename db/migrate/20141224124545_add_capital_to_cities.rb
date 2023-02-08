class AddCapitalToCities < ActiveRecord::Migration
  def change
    add_column :cities, :capital, :boolean, :default => false
    
  end
end
