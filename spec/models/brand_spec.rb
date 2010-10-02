require "spec_helper"

describe Brand do

  before(:each) do
    @user = User.new({ :email => "example@gmail.com", :password => "123456", :password_confirmation => "123456"})
    @attr = { :name => "Example", :address => "www.example.com", :user_id => @user}

  end

  it "should have a user attribute" do
    brand = @user.brands.build({ :name => "Example", :address => "www.example.com"})
    brand.should respond_to(:user)
  end
  
  it "should create a new instance given valid attributes" do
    Brand.create!(@attr)
  end

  it "should requre a user id" do 
    no_user_id = Brand.new(@attr.merge(:user_id => ""))
    no_user_id.should_not be_valid
  end

  it "should require a name" do
    no_name_brand = Brand.new(@attr.merge(:name => ""))
    no_name_brand.should_not be_valid
  end

  it "should require an address" do
    no_address_brand = Brand.new(@attr.merge(:address => ""))
    no_address_brand.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = Brand.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should reject duplicate brand name" do
    # Put a Brand with given name into the database.
    Brand.create!(@attr)
    @attr2 = { :name => "Example", :address => "www.example2.com"}
    brand_with_duplicate_name = Brand.new(@attr2)
    brand_with_duplicate_name.should_not be_valid
  end

  it "should reject duplicate brand address" do
    # Put a Brand with given address into the database.
    Brand.create!(@attr)
    @attr2 = { :name => "Example2", :address => "www.example.com"}
    brand_with_duplicate_address = Brand.new(@attr2)
    brand_with_duplicate_address.should_not be_valid
  end
    
  it "should reject addresses identical up to case" do
    upcased_address = @attr[:address].upcase
    Brand.create!(@attr.merge(:address => upcased_address))
    brand_with_duplicate_address = Brand.new(@attr)
    brand_with_duplicate_address.should_not be_valid
  end
  
  it "should create a new friendship given valid attributes" do
    brand_one = Brand.new({ :name => "Example", :address => "www.example.com"})
    brand_two = Brand.new({ :name => "Example2", :address => "www.example2.com"})
    friendship1 = Friendship.create(:brand_id => brand_one.id, :friend_id => brand_two.id, :status => 'requested')
    friendship2 = Friendship.create(:brand_id => brand_two.id, :friend_id => brand_one.id, :status => 'pending')
    friendship1.should be_valid
    friendship2.should be_valid
  end
  

  
  
  describe "friendship and friend associations" do
    
    before(:each) do
      @brand_one = Brand.new({ :name => "Example", :address => "www.example.com"})
      @brand_two = Brand.new({ :name => "Example2", :address => "www.example2.com"})
      @friendship1 = @brand_one.friendships.build(:brand_id => @brand_one.id, :friend_id => @brand_two.id, :status => 'requested')
      @friendship2 = @brand_two.friendships.build(:brand_id => @brand_two.id, :friend_id => @brand_one.id, :status => 'pending')
    end
    
    it "should have a friendship attribute" do
      @brand_one.should respond_to(:friendships)
    end
    
    it "should have a requested friend attribute" do
      @brand_one.should respond_to(:requested_friends)
    end
       
    it "should have a pending friend attribute" do
      @brand_two.should respond_to(:pending_friends)
    end
    
    it "should have empty accepted friends initially" do
      @brand_one.friends.should be_empty
    end
        
    it "should destroy associated relationship (1)" do
      @brand_one.destroy
      Friendship.find_by_id(@friendship1.id).should be_nil
    end
    
    it "should destroy associated relationship (2)" do
      @brand_one.destroy
      Friendship.find_by_id(@friendship2.id).should be_nil
    end
    
     it "should destroy associated relationship (3)" do
      @brand_two.destroy
      Friendship.find_by_id(@friendship1.id).should be_nil
    end
    
    it "should destroy associated relationship (4)" do
      @brand_two.destroy
      Friendship.find_by_id(@friendship2.id).should be_nil
    end   
  
  end


end
