require "spec_helper"
include Rails.application.routes.url_helpers

describe User do

  before(:all) do
    User.default_url_options[:host] = 'localhost'
  end
  after(:all) do
    User.default_url_options[:host] = nil
  end

  before(:each) do
    @attr = { :email => "example@gmail.com", :password => "123456", :password_confirmation => "123456"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:email => ""))
    no_name_user.should_not be_valid
  end

  it "should require a password" do
    no_password_user = User.new(@attr.merge(:password => ""))
    no_password_user.should_not be_valid
  end
  
  it "should require a confirmed password" do
    no_password_user = User.new(@attr.merge(:password_confirmation => ""))
    no_password_user.should_not be_valid
  end
  
  it "should reject password that are too long" do
    long_password = "a" * 51
    long_password_user = User.new(@attr.merge(:password => long_password, :password_confirmation => long_password))
    long_password_user.should_not be_valid
  end

  it "should reject duplicate User email" do
    # Put a User with given email into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
    
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should create a new brand given valid attributes" do
    valid_user = User.new(@attr)
    valid_brand = valid_user.create_brand({ :name => "Example", :address => "www.example.com"})
    valid_brand.should be_valid
  end
  
  describe "brand associations" do
    
    before(:each) do
      @user = User.new(@attr)
    end
    
    it "should have a brand attribute" do
      @user.should respond_to(:brand)
    end
  
  end

end
