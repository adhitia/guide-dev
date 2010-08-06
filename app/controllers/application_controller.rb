class ApplicationController < ActionController::Base
#  rescue_from ActionController::RoutingError, :with => :handle_error
  rescue_from Exception, :with => :handle_error

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

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
  def unauthenticated
    flash[:error] = 'Oops. You need to login before you can view that page.'
    redirect_to :controller => 'users', :action => 'login'
  end
  def unauthorized
    render :template => "/common/unauthorized.html.erb"
  end
  def error
    render :template => "/common/error.html.erb"
  end


  protected
  
  def set_user
    @current_user = User.find(session[:id]) if @current_user.nil? && session[:id]
  end

=begin

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


=end


  def authenticate
    return true if @current_user

    # redirect user
    session[:return_to] = request.request_uri
    if ajax?
      render :text => 'Please login first', :status => 401
    else
      flash[:error] = 'Oops. You need to login before you can view that page.'
      redirect_to :controller => 'users', :action => 'login'
    end

    return false
  end

  def authorize_guide(guide_id)
    return false if not authenticate
    guide = Calendar.find(guide_id)

    if guide.user_id != @current_user.id
      # action forbidden
      session[:return_to] = request.request_uri
      if ajax?
        render :text => 'Operation is not permitted', :status => 403
      else
        flash[:error] = "You're not authorized to perform this operation"
        redirect_to :controller => :application, :action => :unauthorized
      end
      return false
    end

    return true
  end

  def authorize_user(user_id)
    return false if not authenticate
    user = User.find user_id

    if user.id != @current_user.id
      # action forbidden
      session[:return_to] = request.request_uri
      if ajax?
        render :text => 'Operation is not permitted', :status => 403
      else
        flash[:error] = "You're not authorized to perform this operation"
        redirect_to :controller => :application, :action => :unauthorized
      end
      return false
    end

    return true
  end

  def empty?(s)
    return s == nil || s.strip.empty?;
  end

  def ajax?
    if @ajax == nil
      @ajax = false
    end
    @ajax
  end

  def handle_error(exception)
#    puts "!!!!!!!!!!???  #{exception}"
#    puts "!!!!!!!!!!???  #{clean_backtrace(exception).join("\n  ")}"
    log_error(exception)
    if ajax?
      render :text => 'Error happened', :status => 500
    else
      render :template => "/common/error.html.erb"
    end
  end
end
