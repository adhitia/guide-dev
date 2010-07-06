class UsersController < ApplicationController
  before_filter :login_required, :only => :home

  def login
  end

  def process_login
    if user = User.authenticate(params[:user])
      session[:id] = user.id # Remember the user's id during this session
      if session[:return_to]
        redirect_to session[:return_to]
      else
        redirect_to :action => 'show', :id => user  
      end
    else
      flash[:error] = 'Invalid login.'
      redirect_to :action => 'login', :username => params[:user][:username]
    end
  end

  def logout
    reset_session
    flash[:message] = 'Logged out.'
    redirect_to :action => 'login'
  end

  def home
    @user = @current_user
  end

  def show
    @user = User.find(params[:id])
    if @current_user && (@user.id == @current_user.id)
      @advertised_calendars = Set.new
      @user.advertisements.each do |ad|
        @advertised_calendars.add ad.calendar;
      end
#      puts @advertised_calendars.length
      render :action => 'home'
    end
  end

  def new
    @user = User.new
  end

  def edit
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

end
