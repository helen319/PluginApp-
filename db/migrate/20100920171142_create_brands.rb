class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.string :name
      t.string :address
      t.text :info
          
      t.integer :user_id


      t.timestamps
    end
  end

  def self.down
    drop_table :brands
  end
end
