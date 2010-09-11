class ApplicationController < ActionController::Base
  rescue_from Exception, :with => :handle_error
  rescue_from ActionController::RoutingError, :with => :handle_routing_error

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_user


  protected

  def flatten(hash, result = {}, prefix = "")
    hash.each do |key, value|
      if value.class == Hash
        flatten value, result, prefix + key.to_s
      else
        result[prefix + key.to_s] = value
      end
    end
    result
  end

  def set_user
    @current_user = User.find(session[:id]) if @current_user.nil? && session[:id]
  end


  def authenticate
    return true if @current_user

    # redirect user
    if ajax?
      render :text => 'Please login first', :status => 401
    else
      flash[:error] = 'Oops. You need to login before you can view that page.'
      session[:return_to] = request.request_uri
      redirect_to :controller => :users, :action => 'login'
    end

    return false
  end

  def authorize_guide(guide_id)
    return false if not authenticate
    guide = Calendar.find(guide_id)

    if guide.user_id != @current_user.id
      # action forbidden
      if ajax?
        render :text => 'Operation is not permitted', :status => 403
      else
        flash[:error] = "You're not authorized to perform this operation"
        session[:return_to] = request.request_uri
        redirect_to :controller => :common, :action => :unauthorized
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
      if ajax?
        render :text => 'Operation is not permitted', :status => 403
      else
        flash[:error] = "You're not authorized to perform this operation"
        session[:return_to] = request.request_uri
        redirect_to :controller => :common, :action => :unauthorized
      end
      return false
    end

    return true
  end

  def empty?(s)
    return s == nil || s.strip.empty?;
  end

  def ajax?
    request.headers['X-Requested-With'] == 'XMLHttpRequest' || params['X-Requested-With'] == 'XMLHttpRequest'
  end

  def handle_error(exception)
    puts "regular error"
    custom_log_error exception
    if ajax?
      render :text => 'Error happened', :status => 500
    else
      render :template => "/common/error.html.erb"
    end
  end

  def handle_routing_error(error)
    puts "routing error"
    if ajax?
      custom_log_error exception
      render :text => 'Error happened', :status => 500
    else
#      render :template => "/common/error.html.erb"
      redirect_to '/404.html'
    end
  end

  def custom_log_error(error)
    log_error(error)
    if ENV["RAILS_ENV"] == 'development'
      puts "!!!!!!!!!! error !!!  #{error}   ajax : #{ajax?}"
    elsif ENV["RAILS_ENV"] == 'production'
      Exceptional.handle(exception, "error detected\n ajax request?: #{ajax?}")
    end
  end

  def ban_ie
    if request.env['HTTP_USER_AGENT'] =~ /MSIE/
      redirect_to :controller => :common, :action => :internet_explorer
    end
  end
end
