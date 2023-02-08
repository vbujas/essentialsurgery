class AddQualificationIdToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :qualification_id, :integer
  end
end
