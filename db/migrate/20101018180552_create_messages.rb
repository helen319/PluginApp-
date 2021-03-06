class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :user_id
      t.integer :recipient_id
      t.text :content
      t.text :status #new/read

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
