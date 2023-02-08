class AddRoleToUsers < ActiveRecord::Migration
  def change
    unless column_exists? :users, :role
      add_column :users, :role, :string
    end
  end
end
