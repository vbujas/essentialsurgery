class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.string :story
      t.string :iconclass

      t.timestamps
    end
  end
end
