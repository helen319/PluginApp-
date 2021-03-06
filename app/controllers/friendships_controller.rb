class FriendshipsController < ApplicationController
before_filter :authenticate_user!, :except => [:add_count]


def create
  @brand = Brand.find(params[:brand_id])
  @friend = Brand.find(params[:friend_id])
  # check that current_brand do not have more than 5 friendships.
  if @brand.friends.count + @brand.requested_friends.count == 5
    flash[:alert] = "Unable send request. You can not have more than 5 friendships."
    redirect_to :controller => 'brands', :action => 'show', :id => @brand 
  # check that if friendship (accepted/requested/pending) already exist between brand+friend
  elsif @brand.friendships.find_by_friend_id(params[:friend_id]) != nil ||
          @friend.friendships.find_by_brand_id(params[:brand_id]) != nil
    flash[:alert] = "Friendship already exists."
    redirect_to :controller => 'brands', :action => 'show', :id => @brand 
  else 
    @friendship1 = @brand.friendships.build(:brand_id => @brand.id, :friend_id => @friend.id, :status => 'requested')
    @friendship2 = @friend.friendships.build(:brand_id => @friend.id, :friend_id => @brand.id, :status => 'pending')

    if @friendship1.save && @friendship2.save
      # send a friend_request email to @friend
      @user_friend = User.find(@friend.user_id)
      @brand_name = @brand.name
      UserMailer.friend_request(@user_friend, @brand ,@brand_name).deliver
      flash[:notice] = "Sent a request."
 	  redirect_to :controller => 'brands', :action => 'show', :id => @brand 
    else
 	  flash[:error] = "Unable to created friendship."
 	  redirect_to :controller => 'brands', :action => 'show', :id => @brand 
    end
  end
end

def update
  @brand = Brand.find(params[:brand_id])
  @friend = Brand.find(params[:friend_id])
  # check that current_brand do not have more than 5 friendships.
  if @brand.friends.count + @brand.requested_friends.count == 5
    flash[:alert] = "Unable send request. You can not have more than 5 friendships."
    redirect_to :controller => 'brands', :action => 'show', :id => @brand 
  else 
    params[:friendship1] = {:brand_id => @brand.id, :friend_id => @friend.id, :status => 'accepted', :count_index => 0 }
    params[:friendship2] = {:brand_id => @friend.id, :friend_id => @brand.id, :status => 'accepted', :count_index => 0 }
    @friendship1 = Friendship.find_by_brand_id_and_friend_id(@brand.id, @friend.id)
    @friendship2 = Friendship.find_by_brand_id_and_friend_id(@friend.id, @brand.id)
    if @friendship1.update_attributes(params[:friendship1]) && @friendship2.update_attributes(params[:friendship2])
      flash[:notice] = 'Friend sucessfully accepted!'
      redirect_to :controller => 'brands', :action => 'show', :id => @brand 
    else
      flash[:error] = "Unable to created friendship."
      redirect_to :controller => 'brands', :action => 'show', :id => @brand 
    end
  end
end


def destroy
  @brand = Brand.find(params[:brand_id])
  @friend = Brand.find(params[:friend_id])
  @friendship1 = @brand.friendships.find_by_friend_id(params[:friend_id]).destroy
  @friendship2 = @friend.friendships.find_by_friend_id(params[:brand_id]).destroy
  redirect_to :controller => 'brands', :action => 'show', :id => @brand 
end

def add_count
  @brand = Brand.find(params[:brand_id])
  @friend = Brand.find(params[:friend_id])
  @friendship = Friendship.find_by_brand_id_and_friend_id(@brand.id, @friend.id)
  temp = @friendship.count_index
  params[:friendship] = {:brand_id => @brand.id, :friend_id => @friend.id, :status => 'accepted', :count_index => temp+1}
  if @friendship.update_attributes(params[:friendship]) 
  	if @friend.address.index('http://') == nil
  	  redirect_to "http://" + @friend.address
	else 
	  redirect_to @friend.address
	end
  else  
	flash[:notice] = "failed update count."  
	redirect_to :controller=> 'brands', :action => 'show_friends', :id => @brand
  end
end

end


