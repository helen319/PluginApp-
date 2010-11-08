class HomeController < ApplicationController

  def index
    # or we should go to the user's personalized page
    if user_signed_in?
      redirect_to brands_path 
    end
  end
end
