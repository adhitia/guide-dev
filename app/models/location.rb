class Location < ActiveRecord::Base
  has_one :weather_forecast, :class_name => ::WeatherForecast
end
