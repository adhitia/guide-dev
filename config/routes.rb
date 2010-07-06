
ActionController::Routing::Routes.draw do |map|



  map.with_options :controller => 'tips' do |tips|
    tips.new_tip 'calendars/:id/tips/new', :action => 'new'
    tips.create_tip 'calendars/:id/tips', :action => 'create', :conditions => { :method => :post }
    tips.edit_tip 'calendars/:id/tips/:tip_id/edit', :action => 'edit'
    tips.update_tip 'calendars/:id/tips/:tip_id', :action => 'update', :conditions => { :method => :put }
    tips.follow_url 'calendars/:id/tips/:tip_id/url', :action => 'follow_url'
  end

  map.manage_user '/users/:id/manage', :controller => :users, :action => :manage

  map.connect 'check_location', :controller => :util, :action => :check_location
  map.connect '', :controller => :users, :action => :index
  map.connect 'index', :controller => :users, :action => :index

  map.connect 'calendars/:id/tiny', :controller => :display, :action => :tiny
  map.connect 'calendars/:id/small', :controller => :display, :action => :small
  map.connect 'calendars/:id/normal', :controller => :display, :action => :normal
  map.connect 'calendars/:id/vote/:vote', :controller => :display, :action => :vote

  map.connect 'calendars/:id/advertise', :controller => 'calendars', :action => 'advertise_choose', :conditions => { :method => :get }
  map.advertise_new 'calendars/:id/advertise', :controller => 'calendars', :action => 'advertise', :conditions => { :method => :post }
  map.connect 'calendars/:id/ads', :controller => 'calendars', :action => 'ads'
  map.connect 'calendars', :controller => 'calendars', :action => 'search', :conditions => { :method => :get }

  map.new_calendar 'calendars/new', :controller => :calendars, :action => :new, :conditions => { :method => :get }
  map.new_calendar 'calendars/new', :controller => :calendars, :action => :create, :conditions => { :method => :post }
  map.edit_calendar_day 'calendars/:id/edit_day/:weekday_id', :controller => :calendars, :action => :edit_day
  map.update_tips 'calendars/:id/tips/update', :controller => :tips, :action => :update, :conditions => { :method => :post }
  map.create_tip  'calendars/:id/tips/create', :controller => :tips, :action => :create, :conditions => { :method => :post }
  map.edit_calendar 'calendars/:id/edit', :controller => :calendars, :action => :edit
  map.show_calendar 'calendars/:id', :controller => :calendars, :action => :show, :conditions => { :method => :get }
  map.share_calendar 'calendars/:id/share', :controller => :calendars, :action => :share, :conditions => { :method => :get }
#  map.resources :calendars

  map.show_user 'users/:id', :controller => 'users', :action => 'show', :conditions => { :method => :get }
  map.login 'login', :controller => 'users', :action => 'login'
  map.logout 'logout', :controller => 'users', :action => 'logout'
  map.edit_user 'users/:id/edit', :controller => 'users', :action => 'edit', :conditions => { :method => :get }
  map.update_user 'users/:id/edit', :controller => 'users', :action => 'update', :conditions => { :method => :put }
  map.register 'register', :controller => 'users', :action => 'new', :conditions => { :method => :get }
  map.create_user 'register', :controller => 'users', :action => 'create', :conditions => { :method => :post }

#  map.resources :tips

  map.resources :conditions

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
#  map.connect 'calendars/:id/:action'
#  map.with_options :controller => 'tips' do |tip|
#    tip.show '',  :action => 'list'
#  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
