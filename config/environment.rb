require 'active_record';

# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not  present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
#  config.action_controller.consider_all_requests_local = true

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
#  config.gem "thoughtbot-paperclip", :version => '~> 2.3.0', :lib => 'paperclip', :source =>  'http://gems.github.com'
#  config.gem 'rspec', :lib => 'spec'
#  config.gem 'rspec-rails', :lib => 'spec/rails'
  config.gem "thoughtbot-paperclip", :lib => 'paperclip', :source =>  'http://gems.github.com'

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


#  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
#    if html_tag.start_with? "<label"
#      "<span class=\"fieldWithErrors\">#{html_tag}</span>".html_safe!
#    else
#      if instance.error_message.kind_of?(Array)
#        %(<span class='fieldWithErrors'>#{html_tag}</span>
#        <span class="validation-error">&nbsp;#{instance.error_message.join(',')}</span>)
#      else
#        %(<span class='fieldWithErrors'>#{html_tag}</span>
#        <span class="validation-error">&nbsp;#{instance.error_message}</span>)
#      end
#    end
#  end

  class ActiveRecord::Base
    def errors_as_hash
      result = {}
      errors.each do |attr, message|
        result["[#{attr.gsub(/\./, '][')}]"] = message
      end
      result
    end
  end

#  ActiveRecord::Base.errors_as_hash = Proc.new do
#  end

#
#
#  ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance| "<div class=\"fieldWithErrors\">#{html_tag}</div>".html_safe! }




  #/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8/gems/actionmailer-2.3.5/lib/action_mailer/base.rb
#  config.action_mailer.delivery_method = :sendmail
#  config.action_mailer.raise_delivery_errors = true
#  config.action_mailer.sendmail_settings = {
#          :location       => 'no_such_path',
#          :arguments      => '-i -t'
#  }

=begin


  config.action_mailer.smtp_settings = {
          :address              => "smtp.gmail.com",
#          :port                 => 465,
          :port                 => 587,
#          :domain               => 'baci.lindsaar.net',
          :domain               => 'brazilwide.com.br',
#          :user_name            => 'guiderer.test@gmail.com',
          :user_name            => 'chumbonus.test@gmail.com',
          :password             => 'abcabcabc',
          :authentication       => 'plain',
          :enable_starttls_auto => true
  }


=end




=begin


  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.server_settings = {
          :address => "smtp.gmail.com",
          :port => 465,
#          :domain => "tutorialspoint.com",
          :authentication => :login,
          :user_name => "chumbonus.test@gmail.com",
          :password => "abcabcabc",
  }

=end
end