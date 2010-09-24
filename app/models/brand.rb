class Brand < ActiveRecord::Base
  validates_uniqueness_of :name, :case_sensitive => false 
  validates_uniqueness_of :address, :case_sensitive => false 

  has_many :friends, :through => :friendships, :conditions => "status = 'accepted'"
  has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'"
  has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 'pending'"
  has_many :friendships, :dependent => :destroy

end

