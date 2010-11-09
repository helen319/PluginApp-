class User < ActiveRecord::Base
  has_many :brands,  :dependent => :destroy
  has_many :messages

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable (:confirmable)
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :username
  validates_uniqueness_of :username 
  validates_presence_of   :username
  
  def self.find_for_database_authentication(conditions)
    value = conditions[authentication_keys.first]
    where(["username = :value OR email = :value", { :value => value }]).first
  end
end
