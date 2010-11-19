
# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not  present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  require 'active_record'
  require 'weather_man'

#  config.action_controller.consider_all_requests_local = true

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  config.gem 'xml-simple'
  config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'xml-simple'
  config.gem "thoughtbot-paperclip", :lib => 'paperclip', :source =>  'http://gems.github.com'
  config.gem "prawn", :source =>  'http://gems.github.com'

#  config.gem "factory_girl"


  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  config.gem 'oauth2'
  config.gem 'exceptional'


  class ActiveRecord::Base
    # convert_periods parameter is used to convert 'guide.location.name' into '[guide][location][name]'
    def errors_as_hash(convert_periods = true)
      result = {}
      errors.each do |attr, message|
        if convert_periods
          result["[#{attr.gsub(/\./, '][')}]"] = message
        else
          result[attr] = message
        end
      end
      result
    end
  end


  WeatherMan.partner_id = '1180784909'
  WeatherMan.license_key = '0e1b5b7c95d8cdd8'


  GOOGLE_CHECKOUT = {:id => '149743569739798', :key => 'OEQtO2K1EtS940cpHJTJ0w'} # sandbox
  GOOGLE_CHECKOUT[:url] = "https://sandbox.google.com/checkout/api/checkout/v2/reportsForm/Merchant/#{GOOGLE_CHECKOUT[:id]}"
#  GOOGLE_CHECKOUT = {:id => '907231132431549', :key => 'wpDYYfQs8kC0sTzRbvdjBA'} # production
#  GOOGLE_CHECKOUT[:url] = "https://checkout.google.com/api/checkout/v2/reportsForm/Merchant/#{GOOGLE_CHECKOUT[:id]}"

#  GOOGLE_CHECKOUT = {}
#  GOOGLE_CHECKOUT['sandbox'] = {:id => '149743569739798', :key => 'OEQtO2K1EtS940cpHJTJ0w'}
#  GOOGLE_CHECKOUT['production'] = {:id => '907231132431549', :key => 'wpDYYfQs8kC0sTzRbvdjBA'}

  # maximum number of days guide can have
  DAY_LIMIT = 5
end