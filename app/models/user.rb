class User < ActiveRecord::Base
  has_many :calendars
  has_many :advertisements
  validates_presence_of :name, :email, :identity_url
  validates_uniqueness_of :name, :email, :identity_url, :case_sensitive => false,
                          :message => "Such user already exists"

  validates_format_of :name, :with => /\A[a-zA-Z\d ]*\z/,
    :message => "Only letters, numbers and spaces are allowed"

  validates_length_of :name, :in => 3..25,
                      :too_long => "No more than {{count}} characters allowed",
                      :too_short => "At least {{count}} characters required"
  validates_length_of :email, :maximum => 40,
                      :message => "No more than {{count}} characters allowed"

#  validates_confirmation_of :password#, :on => :create
#  validates_length_of :password, :within => 3..20

  attr_accessible :email, :name, :identity_url

  # If a user matching the credentials is found, returns the User object.
  # If no matching user is found, returns nil.
#  def self.authenticate(user_info)
#    find_by_email_and_password(user_info[:email], user_info[:password])
#  end
end
