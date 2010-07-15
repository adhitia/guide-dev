class Location < ActiveRecord::Base
  has_one :weather_forecast
end
