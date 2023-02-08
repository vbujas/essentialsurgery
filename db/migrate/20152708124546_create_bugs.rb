class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.string :title
      t.string :name
      t.string :email
      t.text :text

      t.timestamps
    end
  end
end
