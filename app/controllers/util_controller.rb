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

    url = URI.parse(GOOGLE_CHECKOUT[:url])
    request = Net::HTTP::Post.new(url.path)
    request.set_form_data({'_type' => 'notification-history-request', 'serial-number' => params['serial-number']})
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true

    #517669820723894-00001-7

    res.set_debug_output $stderr
    result = 'test'
    res.start {|http|
      result = http.request(request)
      puts "111???????????????????? #{result}"
    }

#    result = Net::HTTP.get_response(URI.parse(url))
    puts "???????????????????? #{result}"

#    render :text => "<notification-acknowledgment xmlns='http://checkout.google.com/schema/2' serial-number='#{params['serial-number']}' />"
    render :text => params['serial-number']
  end

  def checkout_test
    serial_number = '517669820723894-00001-7'

    url = URI.parse(GOOGLE_CHECKOUT[:url])
    request = Net::HTTP::Post.new(url.path, {
            'Content-Type' => 'application/xml;charset=UTF-8',
            'Accept' => 'application/xml;charset=UTF-8'
    })
    request.set_form_data({'_type' => 'notification-history-request', 'serial-number' => serial_number})
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true

    res.set_debug_output $stderr
    result = 'test'
    res.start {|http|
      request.basic_auth GOOGLE_CHECKOUT[:id], GOOGLE_CHECKOUT[:key]
      result = http.request(request)
    }

#    result = Net::HTTP.get_response(URI.parse(url))
    puts "???????????????????? #{result}"

    render :text => result.body
  end
end
