

ActionController::Routing::Routes.draw do |map|
  map.resources :util

  map.with_options :controller => :tips do |tips|
    tips.follow_url 'guides/:id/tips/:tip_id/url', :action => 'follow_url'

    tips.tile 'occurrences/:occurrence_id/tile', :controller => :tips, :action => :tile
    tips.delete_tip 'tips/:id/delete', :controller => :tips, :action => :delete
    tips.move_tip 'occurrences/:occurrence_id/move', :controller => :tips, :action => :move
    tips.switch_tips 'occurrences/:occurrence_id/switch', :controller => :tips, :action => :switch
  end


  map.manage_user '/users/:id/manage', :controller => :users, :action => :manage

  map.connect 'check_location', :controller => :util, :action => :check_location
  map.connect 'fetch_gmaps_data', :controller => :util, :action => :fetch_gmaps_data
  map.connect 'checkout_callback', :controller => :util, :action => :checkout_callback

  map.connect 'checkout_test', :controller => :util, :action => :checkout_test
  map.connect 'db_test', :controller => :util, :action => :db_test

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
  map.update_matrix 'guides/:id/update_matrix', :controller => :calendars, :action => :update_matrix
  map.update_tips 'guides/:id/tips/update', :controller => :tips, :action => :update, :conditions => { :method => :post }
  map.create_tip  'guides/:id/tips/create', :controller => :tips, :action => :create, :conditions => { :method => :post }
  map.create_tip  'guides/:id/tips/new', :controller => :tips, :action => :new, :conditions => { :method => :get }
  map.edit_guide 'guides/:id/edit', :controller => :calendars, :action => :edit
  map.show_guide 'guides/:id', :controller => :calendars, :action => :show, :conditions => { :method => :get }
  map.share_guide 'guides/:id/share', :controller => :calendars, :action => :share, :conditions => { :method => :get }
  map.guide_map 'guides/:id/map', :controller => :calendars, :action => :map, :conditions => { :method => :get }
  map.print_guide 'guides/:id/print', :controller => :calendars, :action => :print, :conditions => { :method => :get }

  map.connect 'books/create', :controller => :calendars, :action => :create_book, :conditions => { :method => :post }
  map.connect 'books/:id/print', :controller => :calendars, :action => :create_book, :conditions => { :method => :post }
#  map.change_access_type 'guides/:id'

#  map.new_tip   'tips/new', :controller => :tips, :action => :new, :conditions => { :method => :get }
  map.edit_tip  'tips/:occurrence_id/edit', :controller => :tips, :action => :edit, :conditions => { :method => :get }
  map.show_tip  'tips/:occurrence_id', :controller => :tips, :action => :show, :conditions => { :method => :get }

  map.login 'login', :controller => 'users', :action => 'login'
  map.process_login 'process_login', :controller => 'users', :action => 'process_login'
  map.open_id_complete 'session', :controller => :users, :action => :openid, :conditions => { :method => :get }
  map.oauth_callback 'oauth_callback', :controller => :users, :action => :oauth_callback
  map.logout 'logout', :controller => 'users', :action => 'logout'

  map.show_user 'users/:id', :controller => 'users', :action => 'show', :conditions => { :method => :get }
#  map.edit_user 'users/:id/edit', :controller => 'users', :action => 'edit', :conditions => { :method => :get }
#  map.update_user 'users/:id/edit', :controller => 'users', :action => 'update', :conditions => { :method => :put }
  map.register 'register', :controller => :users, :action => :register #, :conditions => { :method => :post }
#  map.create_user 'register', :controller => 'users', :action => 'create', :conditions => { :method => :post }

  map.connect 'about-us', :controller => :common, :action => :about_us
  map.advertise 'advertise', :controller => :common, :action => :advertise
  map.contact 'contact', :controller => :common, :action => :contact
  map.faq 'faq', :controller => :common, :action => :faq
  map.connect 'how-it-works', :controller => :common, :action => :how_it_works
  map.connect 'join-us', :controller => :common, :action => :join_us
  map.connect 'unauthenticated', :controller => :common, :action => :unauthenticated
  map.connect 'unauthorized', :controller => :common, :action => :unauthorized
  map.connect 'error', :controller => :common, :action => :error
  map.connect 'internet-explorer', :controller => :common, :action => :internet_explorer



  map.connect 'guides/:id/vote/:vote', :controller => :display, :action => :vote
  map.connect 'guides/:id/:layout', :controller => :display, :action => :display
end
