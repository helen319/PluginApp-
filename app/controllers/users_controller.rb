class UsersController < ApplicationController 
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @brands = @user.brands
  end
  
end
