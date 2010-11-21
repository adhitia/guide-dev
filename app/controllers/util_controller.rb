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
    puts "google checkout callback event, sn = #{params['serial-number']}"

    serial_number = params['serial-number']

    url = URI.parse(GOOGLE_CHECKOUT[:url])
    request = Net::HTTP::Post.new(url.path, {
            'Content-Type' => 'application/xml;charset=UTF-8',
            'Accept' => 'application/xml;charset=UTF-8'
    })
    request.set_form_data({'_type' => 'notification-history-request', 'serial-number' => serial_number})
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true

#    res.set_debug_output $stderr
    result = 'test'
    res.start {|http|
      request.basic_auth GOOGLE_CHECKOUT[:id], GOOGLE_CHECKOUT[:key]
      result = http.request(request)
    }

    puts "!!!!!!! result !!!!!!! #{result.body}"
    book_id = result.body.scan(/&amp;shopping-cart.merchant-private-data=([^&]*)&amp;/)[0][0]
    puts "book_id = #{book_id}"

    CommonMailer.deliver_print_order Book.find(book_id)

#    render :text => "<notification-acknowledgment xmlns='http://checkout.google.com/schema/2' serial-number='#{params['serial-number']}' />"
    render :text => params['serial-number']
  end

  def checkout_test
#    serial_number = '517669820723894-00001-7'
    serial_number = '314249553131269-00001-7'
    puts params

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

    puts "???????????????????? #{result}"

    render :text => result.body
  end
end
