class HomeController < ApplicationController
  def index
    # or we should go to the user's personalized page
    redirect_to brands_path if user_signed_in?
    
  end
end
