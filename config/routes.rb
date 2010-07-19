
ActionController::Routing::Routes.draw do |map|



  map.with_options :controller => :tips do |tips|
    tips.new_tip 'calendars/:id/tips/new', :action => 'new'
    tips.create_tip 'calendars/:id/tips', :action => 'create', :conditions => { :method => :post }
    tips.edit_tip 'calendars/:id/tips/:tip_id/edit', :action => 'edit'
    tips.update_tip 'calendars/:id/tips/:tip_id', :action => 'update', :conditions => { :method => :put }
    tips.follow_url 'calendars/:id/tips/:tip_id/url', :action => 'follow_url'

    map.unbind_tip 'occurrences/:occurrence_id/unbind', :controller => :tips, :action => :unbind
    map.unbind_tip 'occurrences/:occurrence_id/move', :controller => :tips, :action => :move
    map.unbind_tip 'occurrences/:occurrence_id/switch', :controller => :tips, :action => :switch
  end

  map.manage_user '/users/:id/manage', :controller => :users, :action => :manage

  map.connect 'check_location', :controller => :util, :action => :check_location
  map.connect '', :controller => :users, :action => :index
  map.connect 'index', :controller => :users, :action => :index

  map.connect 'calendars/:id/advertise', :controller => 'calendars', :action => 'advertise_choose', :conditions => { :method => :get }
  map.advertise_new 'calendars/:id/advertise', :controller => 'calendars', :action => 'advertise', :conditions => { :method => :post }
  map.connect 'calendars/:id/ads', :controller => 'calendars', :action => 'ads'
  map.connect 'calendars', :controller => 'calendars', :action => 'search', :conditions => { :method => :get }

  map.new_calendar 'calendars/new', :controller => :calendars, :action => :new, :conditions => { :method => :get }
  map.new_calendar 'calendars/new', :controller => :calendars, :action => :create, :conditions => { :method => :post }
  map.edit_calendar_day 'calendars/:id/edit_day/:weekday_id', :controller => :calendars, :action => :edit_day
  map.edit_calendar_condition 'calendars/:id/edit_condition/:condition_id', :controller => :calendars, :action => :edit_condition
  map.update_tips 'calendars/:id/tips/update', :controller => :tips, :action => :update, :conditions => { :method => :post }
  map.create_tip  'calendars/:id/tips/create', :controller => :tips, :action => :create, :conditions => { :method => :post }
  map.edit_calendar 'calendars/:id/edit', :controller => :calendars, :action => :edit
  map.show_calendar 'calendars/:id', :controller => :calendars, :action => :show, :conditions => { :method => :get }
  map.share_calendar 'calendars/:id/share', :controller => :calendars, :action => :share, :conditions => { :method => :get }

  map.show_user 'users/:id', :controller => 'users', :action => 'show', :conditions => { :method => :get }
  map.login 'login', :controller => 'users', :action => 'login'
  map.logout 'logout', :controller => 'users', :action => 'logout'
  map.edit_user 'users/:id/edit', :controller => 'users', :action => 'edit', :conditions => { :method => :get }
  map.update_user 'users/:id/edit', :controller => 'users', :action => 'update', :conditions => { :method => :put }
  map.register 'register', :controller => 'users', :action => 'new', :conditions => { :method => :get }
  map.create_user 'register', :controller => 'users', :action => 'create', :conditions => { :method => :post }

  map.connect 'about-us', :controller => :application, :action => :about_us
  map.connect 'advertise', :controller => :application, :action => :advertise
  map.connect 'contact', :controller => :application, :action => :contact
  map.connect 'faq', :controller => :application, :action => :faq
  map.connect 'how-it-works', :controller => :application, :action => :how_it_works
  map.connect 'join-us', :controller => :application, :action => :join_us



  map.connect 'calendars/:id/vote/:vote', :controller => :display, :action => :vote
  map.connect 'calendars/:id/tiny', :controller => :display, :action => :tiny
  map.connect 'calendars/:id/small', :controller => :display, :action => :small
  map.connect 'calendars/:id/normal', :controller => :display, :action => :normal
  map.connect 'public.js', :controller => :display, :action => :public

#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
