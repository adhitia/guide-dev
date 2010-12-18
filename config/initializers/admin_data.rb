AdminData::Config.set = {
  :is_allowed_to_view => lambda {|controller|
    begin
      user = controller.authenticate
      user.admin
    rescue ApplicationController::AuthenticationError
      false
    end
  },
  :is_allowed_to_update => lambda {|controller| false },
#  :is_allowed_to_view => lambda {|controller| controller.send('logged_in?') },
#  :is_allowed_to_update => lambda {|controller| controller.send('admin_logged_in?') },
}