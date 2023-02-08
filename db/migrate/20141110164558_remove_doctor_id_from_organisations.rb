class RemoveDoctorIdFromOrganisations < ActiveRecord::Migration
  def change
    remove_column :organisations, :doctor_id
  end
end
