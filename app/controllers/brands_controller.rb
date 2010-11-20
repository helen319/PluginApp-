class BrandsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :show_friends]
  layout "application", :except => [:show_friends]

  # GET /brands
  # GET /brands.xml
  def index
    if params[:search]
      @brands = Brand.find(:all, :conditions => ['name LIKE?', "%#{params[:search]}%"])
    else 
      @brands = Brand.all
    end
    if user_signed_in? and current_user.brands.length == 0
      redirect_to :controller => 'brands', :action => 'new'
    end
  end

  # GET /brands/1
  # GET /brands/1.xml
  def show
    if RAILS_ENV == "development"
      @ip = "localhost:3000"
    elsif RAILS_ENV == "production"
      @ip = "http://97.107.133.173"
    end

    @brand = Brand.find(params[:id])
    @brands = Brand.all
    @user_brands = current_user.brands
    @friends = @brand.friends
    @friendships_as_brand = []
    @friendships_as_friend = []
    for f in @friends
      friendship1 = Friendship.find_by_brand_id_and_friend_id(@brand.id, f.id)
      friendship2 = Friendship.find_by_brand_id_and_friend_id(f.id, @brand.id)
      @friendships_as_brand << friendship1
      @friendships_as_friend << friendship2
    end    
    # variable for instructions to widget
    @script = '<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<script type="text/javascript" src="' + @ip + '/colorbox/jquery.colorbox.js"></script>
<link rel="stylesheet" media="screen" type="text/css" href="' + @ip + '/colorbox/colorbox.css" />

<script type="text/javascript">
  $(document).ready(function() {	
    $("#open_colorbox").colorbox({width:"50%", height:"80%", iframe:true});
  });
</script>
    
<style type="text/css">
  #widget {
	position:fixed;
	top:250px;
	right: 0px;
  }
</style>'
    @widget_div = '
<div id="widget"><a id="open_colorbox" href="' + @ip + '/brands/show_friends/' + params[:id] + '"><img src="' + @ip + '/images/logo_vertical.png" /></a></div>'
    
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
          format.html { redirect_to(@brand, :notice => 'Link Node was successfully created.') }
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
    if @brand.user == current_user
      respond_to do |format|
        if @brand.update_attributes(params[:brand])
          format.html { redirect_to(@brand, :notice => 'Link Node was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
        end
      end
    else 
      #brand's user is not current user, do nothing.
      redirect_to(:root)
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.xml
  def destroy
    @brand = Brand.find(params[:id])
    if @brand.user == current_user
      @brand.destroy
      respond_to do |format|
        format.html { redirect_to(:root, :notice => 'Link Node was successfully deleted.') }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to(:root)}
        format.xml  { head :ok }
      end
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
 
  
  def remove_photo
    @brand = Brand.find(params[:id])
    @brand.destroy_attached_files
    @brand.save
    redirect_to @brand
  end
end



