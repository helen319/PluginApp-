class BrandsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]
  
  # GET /brands
  # GET /brands.xml
  def index
    @brands = Brand.all
    if user_signed_in? and current_user.brand == nil 
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
    if current_user.brand != nil 
      #current_user already have a existing brand.
      flash[:alert] = "You already have a Brand, please Remove the previous one to create a new Brand."
      redirect_to :controller => 'brands', :action => 'index'
    else
    @brand = current_user.create_brand(params[:brand])
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
      format.html { redirect_to(brands_url) }
      format.xml  { head :ok }
    end
  end
end
