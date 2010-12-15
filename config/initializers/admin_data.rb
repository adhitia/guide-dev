AdminData::Config.set = {
  :is_allowed_to_view => true, # TODO fix me
  :is_allowed_to_update => true,
#  :is_allowed_to_view => lambda {|controller| controller.send('logged_in?') },
#  :is_allowed_to_update => lambda {|controller| controller.send('admin_logged_in?') },
}