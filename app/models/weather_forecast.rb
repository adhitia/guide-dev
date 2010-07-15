class WeatherForecast < ActiveRecord::Base
  belongs_to :location

  serialize :data, ::Array
end
