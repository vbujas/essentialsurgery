class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.string :name
      t.integer :doctor_id

      t.timestamps
    end
  end
end
