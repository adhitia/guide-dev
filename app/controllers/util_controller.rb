require 'net/http'
require 'uri'

class UtilController < ApplicationController
  layout nil

  skip_before_filter :verify_authenticity_token

  def check_location
    @ajax = true

    q = params[:term]
    if q == nil || q == ''
      render :text => ''
      return
    end

    result = [];
    WeatherMan.search(q).each do |l|
      result.push({:label => l.name, :id => l.code})
    end

    render :json => result
  end

  def fetch_gmaps_data
    url = params[:url]
    render :text => Net::HTTP.get(URI.parse(url))
  end

  def checkout_callback
    puts "!!!!!!!!!!!!!!!!!!!!!!!!! google checkout callback event "
    p params
    puts "!!!!!!!! #{params['serial-number']}"

    render :text => params['serial-number']
  end
end
