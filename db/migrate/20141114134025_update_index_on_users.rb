class UpdateIndexOnUsers < ActiveRecord::Migration
  def change
    if index_exists?(:users, :email)
      sql = 'DROP INDEX index_users_on_email'
      sql << ' ON users'
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
