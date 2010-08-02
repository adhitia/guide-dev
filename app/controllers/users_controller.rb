require_library_or_gem 'oauth2'

class UsersController < ApplicationController
#  before_filter :login_required, :only => :home

  def login
  end

  def process_login
    if params[:oauth_server] != nil && params[:oauth_server] != ''
      login_oauth
    else
      login_openid
    end
  end

  def login_oauth
    # scope=email
    redirect_to oauth_client.web_server.authorize_url(
      :redirect_uri => oauth_callback_url(:oauth_server => params[:oauth_server]),
      :scope => 'email'
    )
  end

  def oauth_callback
    access_token = oauth_client.web_server.get_access_token(
      params[:code], :redirect_uri => oauth_callback_url(:oauth_server => params[:oauth_server])
    )

    user_json = access_token.get('/me')
    user_data = ActiveSupport::JSON.decode(user_json)
    identity_url = "synthetic-open-id/facebook/" + user_data["id"];
    finish_login identity_url, user_data["email"], user_data["name"]
  end

  def login_openid
    authenticate_with_open_id(params[:openid_identifier], :required => [:nickname, :email]) do |result, identity_url, registration|
      if result.successful?
        finish_login identity_url, registration['email'], registration['nickname']
      else
        flash[:error] = result.message
        redirect_to :action => :login #, :username => params[:user][:username]
      end
    end
  end

  def finish_login(identity_url, email, name)
    user = User.find_or_initialize_by_identity_url(identity_url)
    if user.new_record?
      user.name = name
      user.email = email
      user.save(false)
    end

    session[:id] = user.id # Remember the user's id during this session
    if (user.name == nil || user.email == nil)
      redirect_to edit_user_url(:id => user)
      return
    end


    if session[:return_to]
      redirect_to session[:return_to]
    else
      redirect_to :action => :show, :id => user
    end
  end


  def logout
    reset_session
    flash[:message] = 'Logged out.'
    redirect_to :action => 'login'
  end

  def home
    return unless authenticate
    @user = @current_user
  end

  def show
    @user = User.find(params[:id])
    if @current_user && (@user.id == @current_user.id)
#      @advertised_calendars = Set.new
#      @user.advertisements.each do |ad|
#        @advertised_calendars.add ad.calendar;
#      end
#      puts @advertised_calendars.length
      render :action => 'home'
    end
  end

  def new
    @user = User.new
  end

  def edit
    return unless authorize_user params[:id]

    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:id] = @user.id # login automatically
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to({:action => 'show', :id => @user}) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    return unless authorize_user params[:id]

    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to :action => 'show', :id => @user }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def index
    @calendars = Calendar.find(:all, :order => "created_at DESC")
    @calendars_amount = @calendars.size
    @recent_calendars = Calendar.find(:all, :limit => 3, :order => "created_at DESC")
    @locations = Location.all

#    file = File.open("temp.txt", "r")
#    puts "?? #{file.readline}"
#    file.close

    file = File.new("temp.txt", "w")
    file.puts "abc"
    file.puts "xyz"
    file.close
#
    File.open("myfile.#{params[:file_type]}", 'w') { |f|
      f.write(params[:text])
    }

    puts "!!!!!!!!!!!!!!!!!"
  end


  protected


  def oauth_client
    @client ||= OAuth2::Client.new(FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, :site => params[:oauth_server])
  end
end
