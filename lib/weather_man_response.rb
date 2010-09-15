require 'ostruct'
require 'date'
require 'time'

class WeatherManResponse
  attr_reader :current_conditions, :forecast, :api_url, :unit_temperature, :unit_distance, :unit_speed, :unit_pressure, :links, :local_time

  def initialize(xml, url = nil)
    xml = xml['weather'] unless xml['weather'].nil? 
    @current_conditions = xml['cc'] ? build_current_conditions(xml['cc']) : nil
    @forecast = xml['dayf'] ? build_forecast(xml['dayf']['day']) : nil

    # Promotional links required by Weather Channel, Inc.
    @links = xml['lnks'] ? build_links(xml['lnks']['link']) : nil

    # Capture the units
    @unit_temperature = xml['head']['ut']
    @unit_distance    = xml['head']['ud']
    @unit_speed       = xml['head']['us']
    @unit_pressure    = xml['head']['up']

    # Capture some location info
    @local_time = Time.parse(xml['loc']['tm'])

    # The api url that was called to generate this response
    @api_url = url
  end

  protected
    def build_current_conditions(response = {})
      return nil if response.nil? || response.empty?

      cc = WeatherManCurrentConditions.new

      # Parse out Current Conditions
      cc.temperature          = response['tmp']
      cc.feels_like           = response['flik']
      cc.description          = response['t']
      cc.icon_code            = response['icon']
      cc.humidity             = response['hmid']
      cc.visibility           = response['vis']
      cc.dew_point            = response['dewp']
      cc.barometric_pressure  = WeatherManBarometer.new({
                                  :reading      => response['bar']['r'],
                                  :description  => response['bar']['d']
                                })
      cc.wind                 = WeatherManWind.new({
                                  :speed        => response['wind']['s'],
                                  :gust         => response['wind']['gust'],
                                  :degrees      => response['wind']['d'],
                                  :direction    => response['wind']['t']
                                })
      cc.uv                   = WeatherManUV.new({
                                  :index        => response['uv']['i'],
                                  :description  => response['uv']['t']
                                })
      cc.moon                 = WeatherManMoon.new({
                                  :icon_code    => response['moon']['icon'],
                                  :description  => response['moon']['t']
                                })
      cc
    end

    def build_forecast(days = [])
      return nil if days.nil? || days.empty?

      f = WeatherManForecast.new
      days.each do |day|
        f << WeatherManForecastDay.build(day)
      end
      f
    end

    def build_links(links = [])
      return nil if links.nil? || links.empty?

      links.map {|link| WeatherManPromotionalLink.new({
        :text => link['t'],
        :url  => link['l']
      })}
    end
end

class WeatherManCurrentConditions
  attr_accessor :temperature,
                :feels_like,
                :description,
                :icon_code,
                :humidity,
                :visibility,
                :dew_point,
                :barometric_pressure,
                :wind,
                :uv,
                :moon
end

class WeatherManForecast < Array
  WEEK_DAYS = %w(sunday monday tuesday wednesday thursday friday saturday)
  WEEK_DAYS.each {|day| attr_reader day.to_sym}

  # Assign a forecast day to a week day accessor as it gets added
  # allows for accessors like forecast.monday -> <WeatherManForecastDay>
  def <<(day)
    super
    eval("@#{day.week_day.downcase} = day")
  end

  def today
    self[0]
  end

  def tomorrow
    self[1]
  end

  # Returns a forecast for a day given by a Date, DateTime,
  # Time, or a string that can be parsed to a date
  def for(date = Date.today)
    # Format date into a Date class
    date = case date.class.name
           when 'String'
             Date.parse(date)
           when 'Date'
             date
           when 'DateTime'
             Date.new(date.year, date.month, date.day)
           when 'Time'
             Date.new(date.year, date.month, date.day)
           end

    day = nil
    # find the matching forecast day, if any
    self.each do |fd|
      day = fd if date == fd.date
    end
    return day
  end
end

class WeatherManForecastDay
  attr_accessor :week_day,
                :date,
                :high,
                :low,
                :sunrise,
                :sunset,
                :day,
                :night

  # Build a new WeatherManForecastDay based on
  # A response from the Weather Channel
  def self.build(response = {})
    fd = new
    fd.week_day = response['t']
    fd.date     = Date.parse(response['dt'])
    fd.high     = response['hi']
    fd.low      = response['low']
    fd.sunrise  = response['sunr']
    fd.sunset   = response['suns']
    fd.day      = build_part(response['part'].first)
    fd.night    = build_part(response['part'].last)
    fd
  end

  protected
    # Build a part day
    def self.build_part(part)
      WeatherManForecastPart.new({
        :icon_code            => part['icon'],
        :description          => part['t'],
        :chance_percipitation => part['ppcp'],
        :humidity             => part['hmid'],
        :wind                 => WeatherManWind.new({
                                   :speed     => part['wind']['s'],
                                   :gust      => part['wind']['gust'],
                                   :degrees   => part['wind']['d'],
                                   :direction => part['wind']['t']
                                 })
      })
    end
end

# =================================
# WeatherMan Response classes
# used for tracking groups of data
# ie. Forecast parts, Barometer,
# UV, Moon, and Wind
# =================================
class WeatherManForecastPart < OpenStruct
end

class WeatherManBarometer < OpenStruct
end

class WeatherManUV < OpenStruct
end

class WeatherManMoon < OpenStruct
end

class WeatherManWind < OpenStruct
end

class WeatherManPromotionalLink < OpenStruct
end