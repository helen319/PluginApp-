class UserMailer < ActionMailer::Base
  default :from => "helen@pluginapp.com"
  
  def friend_request(user, brand_name)
    @user = user.brand
    @brand_name = brand_name
    mail(:to => user.email, :subject => "You have a new friend request!")
  end
end
