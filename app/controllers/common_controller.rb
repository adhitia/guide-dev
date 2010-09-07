class CommonController < ApplicationController
  def about_us
    render :template => "/common/about-us.html.erb"
  end
  def faq
#    render :template => "/common/faq.html.erb"
  end
  def how_it_works
    render :template => "/common/how-it-works.html.erb"
  end
  def join_us
    render :template => "/common/join-us.html.erb"
  end
  def unauthenticated
    flash[:error] = 'Oops. You need to login before you can view that page.'
    redirect_to :controller => :users, :action => 'login'
  end
  def unauthorized
#    render :template => "/common/unauthorized.html.erb"
  end
  def error
#    render :template => "/common/error.html.erb"
  end
  def internet_explorer
    render :template => "/common/internet-explorer.html.erb"
  end
  def contact
    if request.post?
      # read and validate parameters
      @name = params[:name]
      @email = params[:email]
      @message = params[:message]

      @errors = {}
      @errors[:name] = 'Required field' if @name.blank?
      @errors[:email] = 'Required field' if @email.blank?
      @errors[:message] = 'Required field' if @message.blank?
      if !@errors.empty?
        return
      end


      # send email
      CommonMailer.deliver_contact_us @name, @email, @message
      flash[:notice] = "Message had been sent!"
    end
  end

end
