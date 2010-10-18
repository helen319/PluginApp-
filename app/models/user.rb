class User < ActiveRecord::Base
  has_many :brands,  :dependent => :destroy
  has_many :messages

  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable (:confirmable)
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :username
end
