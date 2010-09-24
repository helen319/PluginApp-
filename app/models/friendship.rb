class Friendship < ActiveRecord::Base
  belongs_to :brand
  belongs_to :friend, :class_name => "Brand", :foreign_key =>'friend_id'
end

