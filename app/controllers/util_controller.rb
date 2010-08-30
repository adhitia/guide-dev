require 'net/http'
require 'uri'

class UtilController < ApplicationController
  layout nil

#  def check_location
#    WeatherMan.partner_id = '1180784909'
#    WeatherMan.license_key = '0e1b5b7c95d8cdd8'
#
#    q = params[:q];
#    if q == nil
#      q = params[:term]
#    end
#    if q == nil || q == ''
#      render :text => ''
#      return
#    end
#
#    result = "";
#    WeatherMan.search(q).each do |l|
#      result += "\n" + l.name + "|" + l.id
#      puts "found #{l.name}"
#    end
#
#    render :text => result
#  end

  def check_location
    @ajax = true

    WeatherMan.partner_id = '1180784909'
    WeatherMan.license_key = '0e1b5b7c95d8cdd8'

    q = params[:term]
    if q == nil || q == ''
      render :text => ''
      return
    end

    result = [];
    WeatherMan.search(q).each do |l|
      result.push({:label => l.name, :id => l.id}) 
    end

    render :json => result
  end

  def fetch_gmaps_data
    url = params[:url]
    render :text => Net::HTTP.get(URI.parse(url))
  end
end
