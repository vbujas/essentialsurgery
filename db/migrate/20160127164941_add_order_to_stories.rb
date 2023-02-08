class  AddOrderToStories < ActiveRecord::Migration
    def change
    add_column :stories, :order, :integer, :default => 0, :null => false

  end
end



