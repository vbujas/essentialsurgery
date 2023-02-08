class AddOrganisationIdToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :organisation_id, :integer
  end
end
