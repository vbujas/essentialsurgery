class AddPersonRoleToNgos < ActiveRecord::Migration
  def change

    add_column :ngos, :person_role, :text

  end
end
