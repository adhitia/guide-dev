class Attraction < ActiveRecord::Base
  has_many :tips #, :order => 'calendar.rating'
  belongs_to :city, :class_name => 'Location'


  validates_presence_of :lat, :lng, :popularity, :identity_url
#  validates_length_of :address, :maximum => 255,
#                      :too_long => "no more than {{count}} characters expected"

end
