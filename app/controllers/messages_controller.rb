class MessagesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /messages
  # GET /messages.xml
  def index
    @recieved_messages = Message.find(:all,:order => "created_at desc", :conditions => {:recipient_id => current_user})
    @sent_messages = Message.find(:all,:order => "created_at desc", :conditions => {:user_id => current_user})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])
    if @message.recipient_id == current_user.id
      @message.status = 'read'
      @message.save
    end
    @user = User.find(@message.user_id)
    @recipient = User.find(@message.recipient_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new
    @recipient =  User.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    @message.user_id = params[:sender_id]  
    @message.recipient_id = params[:recipient_id]
    @message.status = 'new'
    
    respond_to do |format|
      if @message.save
        # send a friend_request email to @friend
        @sender = User.find(params[:sender_id])
        @recipient = User.find(params[:recipient_id])
        UserMailer.message_alert(@sender, @recipient).deliver
        format.html { redirect_to(@message, :notice => 'Message was successfully created.') }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to(@message, :notice => 'Message was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
