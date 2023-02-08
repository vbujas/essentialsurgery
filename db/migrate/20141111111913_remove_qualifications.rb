class RemoveQualifications < ActiveRecord::Migration
  def change
    drop_table :qualifications
  end
end
