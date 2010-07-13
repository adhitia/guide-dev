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
    @dow = Weekday.find((Date.today + @day).cwday);

    @calendar.view_count += 1;
    @calendar.save

    @weather_forecast = get_weather_forecast(@day, 1)[0]
    @tips = @calendar.show_places.select {|t| t.weekday.id == @dow.id and condition_matches_weather?(t.condition, @weather_forecast.condition)}
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

  def get_weather_forecast(start, days)
    WeatherMan.partner_id = '1180784909'
    WeatherMan.license_key = '0e1b5b7c95d8cdd8'
    location = WeatherMan.new(@calendar.location.code)
    weather = location.fetch(:days => start + days + 1, :unit => 'm') # , :current_conditions => true
    result = Array.new
    for day in start..start + days - 1
      forecast = weather.forecast.for(Date.today + day)
      weather_condition = forecast.day.description
      if (weather_condition == "N/A") then
        weather_condition = forecast.night.description
      end
      data = WeatherForecast.new(process_weather(weather_condition), weather_condition)
      result.push data
    end
    result
  end

  def process_weather(description)
    description = description.downcase
    if description.index('rain') or description.index('storms') or description.index('showers') then
      'rainy'
    elsif description.index('cloud') then
      'cloudy'
    else
      'sunny'
    end
  end
# Sunny, Fair, Clear
# Partly Cloudy, Mostly Cloudy
# Light Rain
# Scattered T-Storms
# T-Showers, Showers Late, Showers


  def condition_matches_weather?(condition, weather)
    weather = weather.downcase
    condition = condition.name.downcase
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
end




class WeatherForecast
  attr_accessor :condition, :original_condition

  def initialize(condition, original_condition)
    @condition = condition
    @original_condition = original_condition
  end
end

