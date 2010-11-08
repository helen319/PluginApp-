class AddUsernameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string, :unique => true
  end

  def self.down
    remove_column :users, :username
  end
end
