class Brand < ActiveRecord::Base
  belongs_to :user
    
  validates_uniqueness_of :name, :case_sensitive => false 
  validates_uniqueness_of :address, :case_sensitive => false
  validates :name, :presence => true,
                   :length   => { :maximum => 50 }
  validates :address, :presence => true
  validates :user_id, :presence => true

  has_many :friends, :through => :friendships, :conditions => "status = 'accepted'"
  has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'"
  has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 'pending'"
  has_many :friendships, :dependent => :destroy

  has_attached_file :photo, :dependent => :destroy, :styles => {:small => "150x150>" }
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
end

