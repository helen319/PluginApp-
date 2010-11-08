class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  if ENV["RAILS_ENV"] == "development"
    @ip = "localhost:3000"
  elsif ENV["RAILS_ENV"] == "production"
    @ip = "http://97.107.133.173"
  end
  
end