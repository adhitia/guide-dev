class User < ActiveRecord::Base
  has_one :photo, :as => :imageable, :dependent => :destroy

  accepts_nested_attributes_for :photo, :reject_if => lambda { |t| t['image'].blank? }

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

  before_validation { |user|
    user.name = '' if user.name.blank?
    user.name.gsub! /[\s]+/, ' '
    user.name.strip!
  }


end
