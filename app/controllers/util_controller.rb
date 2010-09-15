require 'net/http'
require 'uri'

class UtilController < ApplicationController
  layout nil

#  def check_location
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
end
