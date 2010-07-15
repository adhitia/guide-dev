require 'rubygems'
require 'weather_man'
require 'calendars_helper'

class DisplayController < ApplicationController
  layout nil

  after_filter :jsonp, :except => :public


  def public
    render :file => 'app/views/display/public.js.erb'
  end


  def tiny
    @calendar = Calendar.find(params[:id])
    @weekdays = Weekday.all
    @day = params[:day]
    if @day == nil then
      @day = 0
    else
      @day = @day.to_i
    end
    start_date = Date.today + @day
    @dow = Weekday.find(start_date.cwday);

    @calendar.view_count += 1;
    @calendar.save

    @weather_forecast = get_forecast(@calendar.location.id, 0, 1)[0]
    @tips = @calendar.show_places.select {|t| t.weekday.id == @dow.id and (t.condition.weather == nil || t.condition.weather == @weather_forecast.condition)}
    @tips.each do |tip|
      tip.tip.view_count += 1;
      tip.tip.save;
    end

    @rating = @calendar.rating_num;

    respond_to do |format|
      format.html
    end
  end

  def small
    tiny
  end

  def normal
    tiny
  end


  # vote for the calendar
  def vote
    @calendar = Calendar.find(params[:id])
    vote = params[:vote].to_i

    @calendar.votes_sum += vote
    @calendar.votes_num += 1
    @calendar.save

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
      body = response.body
      body = body.gsub '"', '\\"'
      body = body.gsub /\n/, '\\n';
      body = body.gsub '/', '\\/';
      body = params[:callback] + '("' + body + '");';
      response.body = body;
    end
  end




  def get_forecast(location_id, start, days)
    location = Location.find location_id
    forecast = location.weather_forecast

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

    forecast.data[start, days]
  end

  

  def get_forecast_weather_dot_com(location_code)
    WeatherMan.partner_id = '1180784909'
    WeatherMan.license_key = '0e1b5b7c95d8cdd8'
    days_fetch = 4;

    location = WeatherMan.new(location_code)
    weather = location.fetch(:days => days_fetch + 1, :unit => 'm') # , :current_conditions => true
    result = Array.new
    for day in 0..days_fetch - 1
      forecast = weather.forecast.for(Date.today + day)
      weather_condition = forecast.day.description
      if (weather_condition == "N/A") then
        weather_condition = forecast.night.description
      end
      data = WeatherForecastData.new(process_weather(weather_condition), weather_condition)
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
  attr_accessor :condition, :original_condition

  def initialize(condition, original_condition)
    @condition = condition
    @original_condition = original_condition
  end
end


