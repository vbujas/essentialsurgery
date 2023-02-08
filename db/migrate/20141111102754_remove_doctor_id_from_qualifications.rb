class RemoveDoctorIdFromQualifications < ActiveRecord::Migration
  def change
    remove_column :qualifications, :doctor_id
  end
end
