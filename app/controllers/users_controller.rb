require_library_or_gem 'oauth2'

class UsersController < ApplicationController

  def login
  end

  def process_login
    if params[:oauth_server] != nil && params[:oauth_server] != ''
      login_oauth
    else
      login_openid
    end
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


  def logout
    reset_session
    flash[:message] = 'Logged out.'
    redirect_to :action => 'login'
  end

  def show
    @user = User.find(params[:id])
    if @current_user && (@user.id == @current_user.id)
      render :action => 'home'
    end
  end

  def home
    return unless authenticate
    @user = @current_user
  end


#  def new
#    @user = User.new
#  end

  def edit
    return unless authorize_user params[:id]

    @user = User.find(params[:id])
  end

#  def create
#    @user = User.new(params[:user])
#
#    respond_to do |format|
#      if @user.save
#        session[:id] = @user.id # login automatically
#        flash[:notice] = 'User was successfully created.'
#        format.html { redirect_to({:action => 'show', :id => @user}) }
#      else
#        format.html { render :action => "new" }
#      end
#    end
#  end

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
  end

  def register
    if params[:user][:identity_url].blank?
      puts "no identity url provided"
      redirect_to login_path
      return
    end

    @user = User.new(params[:user])
    @user.name.gsub! /[\s]+/, ' '
    @user.name.strip!
    if request.post?
      if @user.save
        session[:id] = user.id # Remember the user's id during this session
        if session[:return_to]
          redirect_to session[:return_to]
        else
          redirect_to :action => :show, :id => @user
        end
      else
        @errors = flatten({:user => @user.errors_as_hash})
      end
    end
  end

  protected


  def oauth_client
    @client ||= OAuth2::Client.new(FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, :site => params[:oauth_server])
  end

  def login_oauth
    redirect_to oauth_client.web_server.authorize_url(
      :redirect_uri => oauth_callback_url(:oauth_server => params[:oauth_server]),
      :scope => 'email'
    )
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
#    user = User.find_or_initialize_by_identity_url(identity_url)
    user = User.find_by_identity_url(identity_url)
#    if user.new_record?
    if user.nil?
      redirect_to register_path("user[email]" => email, "user[name]" => name, "user[identity_url]" => identity_url)
#      user.name = name
#      user.email = email
#      user.save(false)
      return
    end

    session[:id] = user.id # Remember the user's id during this session
#    if (user.name == nil || user.email == nil)
#      redirect_to edit_user_url(:id => user)
#      return
#    end


    if session[:return_to]
      redirect_to session[:return_to]
    else
      redirect_to :action => :show, :id => user
    end
  end
end
