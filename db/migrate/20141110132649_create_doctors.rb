class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.string :title
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :email
      t.integer :fellow_type_id
      t.string :gender
      t.integer :specialty_id
      t.integer :city_id
      t.integer :country_id

      t.timestamps
    end
  end
end
