class CreateFellowTypes < ActiveRecord::Migration
  def change
    create_table :fellow_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
