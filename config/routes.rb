
ActionController::Routing::Routes.draw do |map|
  map.resources :util

  map.with_options :controller => :tips do |tips|
    tips.follow_url 'guides/:id/tips/:tip_id/url', :action => 'follow_url'

    map.tile 'occurrences/:occurrence_id/tile', :controller => :tips, :action => :tile
    map.unbind_tip 'occurrences/:occurrence_id/unbind', :controller => :tips, :action => :unbind
    map.move_tip 'occurrences/:occurrence_id/move', :controller => :tips, :action => :move
    map.switch_tips 'occurrences/:occurrence_id/switch', :controller => :tips, :action => :switch
  end

  map.manage_user '/users/:id/manage', :controller => :users, :action => :manage

  map.connect 'check_location', :controller => :util, :action => :check_location
  map.connect 'fetch_gmaps_data', :controller => :util, :action => :fetch_gmaps_data
  map.connect '', :controller => :users, :action => :index
#  map.connect 'index', :controller => :users, :action => :index

  map.connect 'guides/:id/advertise', :controller => 'calendars', :action => 'advertise_choose', :conditions => { :method => :get }
  map.advertise_new 'guides/:id/advertise', :controller => 'calendars', :action => 'advertise', :conditions => { :method => :post }
  map.connect 'guides/:id/ads', :controller => 'calendars', :action => 'ads'
  map.search 'guides', :controller => 'calendars', :action => 'search', :conditions => { :method => :get }

  map.new_guide 'guides/new', :controller => :calendars, :action => :new, :conditions => { :method => :get }
  map.create_guide 'guides/new', :controller => :calendars, :action => :create, :conditions => { :method => :post }
  map.update_guide 'guides/:id/update', :controller => :calendars, :action => :update
  map.edit_guide_day 'guides/:id/edit_day/:weekday_id', :controller => :calendars, :action => :edit_day
  map.edit_guide_condition 'guides/:id/edit_condition/:condition_id', :controller => :calendars, :action => :edit_condition
  map.update_tips 'guides/:id/tips/update', :controller => :tips, :action => :update, :conditions => { :method => :post }
  map.create_tip  'guides/:id/tips/create', :controller => :tips, :action => :create, :conditions => { :method => :post }
  map.edit_guide 'guides/:id/edit', :controller => :calendars, :action => :edit
  map.show_guide 'guides/:id', :controller => :calendars, :action => :show, :conditions => { :method => :get }
  map.share_guide 'guides/:id/share', :controller => :calendars, :action => :share, :conditions => { :method => :get }

  map.edit_tip  'tips/:occurrence_id/edit', :controller => :tips, :action => :edit, :conditions => { :method => :get }
  map.show_tip  'tips/:occurrence_id', :controller => :tips, :action => :show, :conditions => { :method => :get }

  map.login 'login', :controller => 'users', :action => 'login'
  map.process_login 'process_login', :controller => 'users', :action => 'process_login'
  map.open_id_complete 'session', :controller => :users, :action => :openid, :conditions => { :method => :get }
  map.oauth_callback 'oauth_callback', :controller => :users, :action => :oauth_callback
  map.logout 'logout', :controller => 'users', :action => 'logout'

  map.show_user 'users/:id', :controller => 'users', :action => 'show', :conditions => { :method => :get }
  map.edit_user 'users/:id/edit', :controller => 'users', :action => 'edit', :conditions => { :method => :get }
  map.update_user 'users/:id/edit', :controller => 'users', :action => 'update', :conditions => { :method => :put }
#  map.register 'register', :controller => 'users', :action => 'new', :conditions => { :method => :get }
#  map.create_user 'register', :controller => 'users', :action => 'create', :conditions => { :method => :post }

  map.connect 'about-us', :controller => :application, :action => :about_us
  map.connect 'advertise', :controller => :application, :action => :advertise
  map.connect 'contact', :controller => :application, :action => :contact
  map.connect 'faq', :controller => :application, :action => :faq
  map.connect 'how-it-works', :controller => :application, :action => :how_it_works
  map.connect 'join-us', :controller => :application, :action => :join_us
  map.connect 'unauthenticated', :controller => :application, :action => :unauthenticated
  map.connect 'unauthorized', :controller => :application, :action => :unauthorized
  map.connect 'error', :controller => :application, :action => :error



  map.connect 'guides/:id/vote/:vote', :controller => :display, :action => :vote
  map.connect 'guides/:id/tiny', :controller => :display, :action => :tiny
  map.connect 'guides/:id/small', :controller => :display, :action => :small
  map.connect 'guides/:id/normal', :controller => :display, :action => :normal
#  map.connect 'public.js', :controller => :display, :action => :public

#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
