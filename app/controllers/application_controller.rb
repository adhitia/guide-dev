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
    guide = verify_guide guide_id
    return if guide.nil?

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

  # check that guide is present
  def verify_guide guide_id
    guide = Calendar.find_by_id(guide_id)
    if guide.nil?
      if ajax?
        render :text => "Guide with id [#{guide_id}] isn't found", :status => 404
      else
        flash[:error] = "The guide you requested can't be found."
        render :template => 'common/missing'
      end
    end

    guide
  end

  # check that guide is present
  def verify_tip id
    result = Tip.find_by_id(id)
    if result.nil?
      if ajax?
        render :text => "Tip with id [#{id}] isn't found", :status => 404
      else
        flash[:error] = "The tip you requested can't be found."
        render :template => 'common/missing'
      end
    end

    result
  end

  def empty?(s)
    return s == nil || s.strip.empty?;
  end

  # request.xhr? isn't good enough, because we have iframes with images submitted in background
  # They all have 'X-Requested-With' parameter set 
  def ajax?
    request.headers['X-Requested-With'] == 'XMLHttpRequest' || params['X-Requested-With'] == 'XMLHttpRequest'
  end

  def handle_error(error)
#    puts "regular error"
    custom_log_error error
    if ajax?
      render :text => 'Error happened', :status => 500
    else
      render :template => "/common/error.html.erb"
    end
  end

  def handle_routing_error(error)
    puts "routing error"
    if ajax?
      custom_log_error error
      render :text => 'Error happened', :status => 500
    else
      redirect_to '/404.html'
    end
  end

  def custom_log_error(error)
    Exception
    puts "!!!!!!!!!!!!! error found:\n #{error} \n"
#    puts "!!!!!!!!!!!!! \n#{error.backtrace.join('\n')} \n"
    log_error(error)
    if ENV["RAILS_ENV"] == 'development'
      puts "!!!!!!!!!! error !!!  #{error}   ajax : #{ajax?}"
    elsif ENV["RAILS_ENV"] == 'production'
      Exceptional.handle(error, "error detected\n ajax request?: #{ajax?}")
    end
  end

  # no ie (except guide viewers) so far
  # fix it some time later
  def ban_ie
    if request.env['HTTP_USER_AGENT'] =~ /MSIE/
      redirect_to :controller => :common, :action => :internet_explorer
    end
  end
end
