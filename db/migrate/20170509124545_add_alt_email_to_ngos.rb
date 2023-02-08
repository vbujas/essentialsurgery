class AddAltEmailToNgos < ActiveRecord::Migration
  def change

    add_column :ngos, :alt_email, :string

  end
end
