class User < ActiveRecord::Base
  has_one :brand,  :dependent => :destroy
  #has_many :brand,  :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable (:confirmable)
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
end
