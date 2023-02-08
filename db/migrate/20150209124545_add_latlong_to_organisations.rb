class AddLatlongToOrganisations < ActiveRecord::Migration
  def change

    add_column :organisations, :latitude, :string
    add_column :organisations, :longitude, :string

  end
end
