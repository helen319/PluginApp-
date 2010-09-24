class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :brand_id
      t.integer :friend_id
      t.integer :count_index
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end
