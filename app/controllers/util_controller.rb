class UtilController < ApplicationController

  def check_location
    WeatherMan.partner_id = '1180784909'
    WeatherMan.license_key = '0e1b5b7c95d8cdd8'

    q = params[:q];
    if q == nil || q == ''
      render :text => ''
      return
    end

    result = "";
    WeatherMan.search(q).each do |l|
      result += "\n" + l.name + "|" + l.id
    end

    render :text => result
  end
end
