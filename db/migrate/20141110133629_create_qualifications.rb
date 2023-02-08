class CreateQualifications < ActiveRecord::Migration
  def change
    create_table :qualifications do |t|
      t.string :name
      t.integer :doctor_id

      t.timestamps
    end
  end
end
