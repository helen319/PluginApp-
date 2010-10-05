class BrandsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]
  
  # GET /brands
  # GET /brands.xml
  def index
    @brands = Brand.all
    if user_signed_in? and current_user.brands.length == 0
      redirect_to :controller => 'brands', :action => 'new'
    else 
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @brands }
      end
    end
  end

  # GET /brands/1
  # GET /brands/1.xml
  def show
    @brand = Brand.find(params[:id])
    @brands = Brand.all
    @friends = @brand.friends
    @friendships_as_brand = []
    @friendships_as_friend = []
    for f in @friends
      friendship1 = Friendship.find_by_brand_id_and_friend_id(@brand.id, f.id)
      friendship2 = Friendship.find_by_brand_id_and_friend_id(f.id, @brand.id)
      @friendships_as_brand << friendship1
      @friendships_as_friend << friendship2
    end    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /brands/new
  # GET /brands/new.xml
  def new
    @brand = Brand.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /brands/1/edit
  def edit
    @brand = Brand.find(params[:id])
  end
  
  # POST /brands
  # POST /brands.xml
  def create
    @brand = current_user.brands.build(params[:brand])
      respond_to do |format|
        if @brand.save
          format.html { redirect_to(@brand, :notice => 'Brand was successfully created.') }
          format.xml  { render :xml => @brand, :status => :created, :location => @brand }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
        end
    end
  end

  # PUT /brands/1
  # PUT /brands/1.xml
  def update
    @brand = Brand.find(params[:id])

    respond_to do |format|
      if @brand.update_attributes(params[:brand])
        format.html { redirect_to(@brand, :notice => 'Brand was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.xml
  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end
  
    #shows all friends of @brand, max 5 friends
  def show_friends
    @brand = Brand.find(params[:id])
    respond_to do |format|
      format.html # show_friends.html.erb
      format.xml  { render :xml => @brand }
    end
  end
  
  def add_count
    @brand = Brand.find(params[:brand_id])
    @friend = Brand.find(params[:friend_id])
    @friendship = Friendship.find_by_brand_id_and_friend_id(@brand.id, @friend.id)
    temp = @friendship.count_index
    params[:friendship] = {:brand_id => @brand.id, :friend_id => @friend.id, :status => 'accepted', :count_index => temp+1}
    if @friendship.update_attributes(params[:friendship]) 
		flash[:notice] = 'Count updated.'
		redirect_to :controller=> 'brands', :action => 'show', :id => @friend
	else  
		flash[:notice] = "failed update count."  
		redirect_to :controller=> 'brands', :action => 'show_friends', :id => @brand
    end
  end
end
