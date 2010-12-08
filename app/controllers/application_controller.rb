class ApplicationController < ActionController::Base
  class AuthenticationError < StandardError
  end
  class AuthorizationError < StandardError
  end
  class ResourceNotFoundError < StandardError
  end

  rescue_from Exception, :with => :handle_error
  rescue_from ActionController::RoutingError, :with => :handle_resource_not_found_error
  rescue_from AuthenticationError, :with => :handle_authentication_error
  rescue_from AuthorizationError, :with => :handle_authorization_error
  rescue_from ResourceNotFoundError, :with => :handle_resource_not_found_error

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_user


  protected

  # flattens hash keys just like similar method in Array
  # used for error reporting
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
    raise AuthenticationError.new if @current_user.nil?
    @current_user
  end

  def authorize_guide(guide_id = params[:id])
    authenticate

    guide = verify_guide guide_id
    raise AuthorizationError.new('This operation can be performed by guide owner only.') if guide.user_id != @current_user.id
    guide
  end

  def authorize_user(user_id = params[:id])
    authenticate

    user = verify_user user_id
    raise AuthorizationError.new("You are not authorized to perform this operation.") if user.id != @current_user.id
    user
  end

  def authorize_book(id = params[:id])
    authenticate
    book = verify_book id
    raise AuthorizationError.new('This operation can be performed by guide owner only.') if book.calendar.user_id != @current_user.id
    book
  end

  # check that guide is present
  def verify_guide id
    verify_resource id, Calendar, 'Guide'
  end

  # check that tip is present
  def verify_tip id
    verify_resource id, Tip
  end

  # check that user is present
  def verify_user id
    verify_resource id, User
  end

  def verify_book id
    verify_resource id, Book
  end

  def verify_resource id, type, name = nil
    name = type.to_s if name.nil?
    result = type.find_by_id(Integer(id))
    raise ResourceNotFoundError.new("#{name} with id \"#{id}\" can't be found") if result.nil?
    result
  rescue ArgumentError
    raise ResourceNotFoundError.new("#{name} with id \"#{id}\" can't be found")
  end

  # request.xhr? isn't good enough, because we have iframes with images submitted in background
  # They all have 'X-Requested-With' parameter set 
  def ajax?
    request.headers['X-Requested-With'] == 'XMLHttpRequest' || params['X-Requested-With'] == 'XMLHttpRequest'
  end

  def handle_error(error)
    custom_log_error error
    if ajax?
      render :text => 'error', :status => 500
    else
      render :template => "/common/error.html.erb"
    end
  end

#  def handle_routing_error(error)
#    puts "routing error"
#    if ajax?
#      custom_log_error error
#      render :text => 'Error happened', :status => 500
#    else
#      redirect_to '/404.html'
#    end
#  end

  def custom_log_error(error)
    puts "!!!!!!!!!!!!! error found:\n #{error} \n"
#    puts "!!!!!!!!!!!!! \n#{error.backtrace.join('\n')} \n"
    log_error(error)
    if ENV["RAILS_ENV"] == 'development'
      puts "!!!!!!!!!! error !!!    ajax : #{ajax?}  \n#{error.backtrace.join("\n")}\n"
    elsif ENV["RAILS_ENV"] == 'production'
      Exceptional.context(:params => params, :fullpath => request.fullpath)
      Exceptional.handle(error, "error detected....\n")
    end
  end

  # no ie (except guide viewers) so far
  # fix it some time later
  def ban_ie
    if request.env['HTTP_USER_AGENT'] =~ /MSIE/
      redirect_to :controller => :common, :action => :internet_explorer
    end
  end

  def handle_authentication_error(error)
    if ajax?
      render :text => 'Please login first', :status => 401
    else
      # redirect user
      flash[:error] = 'Oops. You need to login before you can view that page.'
      session[:return_to] = request.request_uri
      redirect_to :controller => :users, :action => 'login'
    end
  end

  def handle_authorization_error(error)
    if ajax?
      render :text => error.message, :status => 403
    else
      flash[:error] = error.message
      session[:return_to] = request.request_uri
      render :template => 'common/unauthorized'
    end
  end

  def handle_resource_not_found_error(error)
    if ajax?
      custom_log_error error
      render :text => error.message, :status => 404
    else
      flash[:error] = error.message
      render :template => 'common/missing'
    end
  end

end
