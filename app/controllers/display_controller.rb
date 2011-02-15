# Serves all needs of guiderer html widget

require 'rubygems'
require 'weather_man'
require 'calendars_helper'

class DisplayController < ApplicationController
  layout 'widget'

#  caches_action :display
  after_filter :jsonp


  def display
#    puts "display guide"
#    response.headers['Cache-Control'] = 'public, max-age=300'

    @calendar = Calendar.find params[:id]
    @weekdays = Weekday.all
    @day = params[:day]
    if @day == nil then
      @day = 0
    else
      @day = @day.to_i
    end

    @tips = @calendar.grouped_tips
    if @day >= @tips.length
      @day = @tips.length - 1
    end
    if @day < 0
      @day = 0
    end

    @rating = @calendar.rating_num

    layout = GuideLayout.find params[:layout]
    render :template => "display/#{layout.path}"
#    puts "???? 1"
#    response = jsonp2(render_to_string :template => "display/#{layout.path}")
#    puts "???? 2"
#    render :text => response
  end


  # vote for the guide
  def vote
    vote = params[:vote].to_i
    old_vote = cookies["guide_vote_#{params[:id]}"]

    @guide = Calendar.find(params[:id], :lock => true)
    if old_vote.nil?
      @guide.votes_sum += vote
      @guide.votes_num += 1
    else
      @guide.votes_sum += vote - old_vote.to_i
    end
    @guide.update_rating
    @guide.save

    cookies["guide_vote_#{@guide.id}"] = vote

    render :text => 'dummy response'
  end


  private

  def condition_matches_weather?(condition, weather)
    weather = weather.downcase
    condition = condition.weather.downcase
    if condition == "cloudy" or condition == "rainy" or condition == "sunny" then
      condition == weather
    else
      true
    end
  end

  def jsonp()
    if params[:callback]
      body = response.body;
      body = body.gsub '"', '\\"';
      body = body.gsub /\n/, '\\n';
      body = body.gsub /\r/, '\\r';
      body = body.gsub '/', '\\/';
      body = params[:callback] + '("' + body + '");';
      response.body = body;
    end
  end
  def jsonp2(body)
    if params[:callback]
#      body = response.body;
      body = body.gsub '"', '\\"';
      body = body.gsub /\n/, '\\n';
      body = body.gsub /\r/, '\\r';
      body = body.gsub '/', '\\/';
      body = params[:callback] + '("' + body + '");';
#      response.body = body;
    end
    body
  end




  def get_forecast(location_id, start = 0, days = :all)
    location = Location.find location_id
    forecast = location.weather_forecast
    if forecast == nil
      forecast = WeatherForecast.create(:location_id => location.id, :last_checked => DateTime.now - 2)
    end

    diff = DateTime.now.to_f - forecast.last_checked.to_f
    now = DateTime.now

    if diff > 60 * 60 || now.min < forecast.last_checked.min || forecast.data == nil #|| true
      # if last update was made more than x minutes ago
      # or hour has changed since that
      # or there's no forecast yet
      puts "last update made #{diff} seconds ago, update #{location.name} forecast now"
      forecast.data = get_forecast_weather_dot_com(location.code)
      forecast.last_checked = DateTime.now
      forecast.save
    end

    if days == :all
      forecast.data[start, forecast.data.length - start]
    else
      forecast.data[start, days]
    end

  end

  

  def get_forecast_weather_dot_com(location_code)
    days_fetch = 3;

    location = WeatherMan.new(location_code)
    weather = location.fetch(:days => days_fetch + 1, :unit => 'm') # , :current_conditions => true
    
    result = Array.new
    for day in 0 .. weather.forecast.length - 1
      forecast = weather.forecast[day]
      weather_condition = forecast.day.description
      if (weather_condition == "N/A") then
        weather_condition = forecast.night.description
      end
      data = WeatherForecastData.new(process_weather(weather_condition), weather_condition, forecast.date)
      result.push data
    end
    result
  end

  def process_weather(description)
    good_weather = Set.new ['sunny', 'fair', 'clear', 'partly cloudy']
    if good_weather.include? description.downcase then
      'sunny'
    else
      'lousy'
    end
  end
# Sunny, Fair, Clear
# Partly Cloudy, Mostly Cloudy
# Light Rain
# Scattered T-Storms
# T-Showers, Showers Late, Showers


end





class WeatherForecastData
  attr_accessor :condition, :original_condition, :date

  def initialize(condition, original_condition, date)
    @condition = condition
    @original_condition = original_condition
    @date = date
  end
end



