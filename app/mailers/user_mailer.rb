class UserMailer < ActionMailer::Base
  default :from => "helen@pluginapp.com"
  
  def friend_request(user, brand, brand_name)
    @brand = brand
    @brand_name = brand_name
    mail(:to => user.email, :subject => "You have a new friend request!")
  end
  
  def message_alert(sender, recipient)
    @sender = sender.username
    mail(:to => recipient.email, :subject => "You have a new message!")
  end
end
