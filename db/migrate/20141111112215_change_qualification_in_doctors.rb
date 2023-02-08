class ChangeQualificationInDoctors < ActiveRecord::Migration
  def change
    remove_column :doctors, :qualification_id
    add_column :doctors, :qualification, :text
  end
end
