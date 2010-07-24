class ApplicationController < ActionController::Base
  rescue_from Exception, :with => :handle_error

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

#   Scrub sensitive parameters from your log
   filter_parameter_logging :password

  before_filter :set_user



  def about_us
    render :template => "/common/about-us.html.erb"
  end
  def faq
    render :template => "/common/faq.html.erb"
  end
  def how_it_works
    render :template => "/common/how-it-works.html.erb"
  end
  def join_us
    render :template => "/common/join-us.html.erb"
  end


  protected
  
  def set_user
    @current_user = User.find(session[:id]) if @current_user.nil? && session[:id]
  end

  def login_required
    return true if @current_user
    access_denied
    return false
  end

  def access_denied
    session[:return_to] = request.request_uri
    flash[:error] = 'Oops. You need to login before you can view that page.'
    redirect_to :controller => 'users', :action => 'login'
  end

  def empty?(s)
    return s == nil || s.strip.empty?;
  end

  def handle_error(exception)
    log_error(exception)
    render :template => "/common/error.html.erb"
  end




end
