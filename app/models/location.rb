class Location < ActiveRecord::Base
  has_one :weather_forecast

  validates_presence_of :code, :name
end
