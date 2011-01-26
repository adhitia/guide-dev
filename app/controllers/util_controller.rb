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

    result = []
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

    result = ''
    res.start {|http|
      request.basic_auth GOOGLE_CHECKOUT[:id], GOOGLE_CHECKOUT[:key]
      result = http.request(request)
    }

#    puts "!!!!!!! result !!!!!!! #{result.body}"
    type = fetch_parameter(result.body, '_type')
    if type == 'order-state-change-notification'
      book_id   = fetch_parameter(result.body, 'order-summary.shopping-cart.merchant-private-data')

      new_state = fetch_parameter(result.body, 'new-fulfillment-order-state') + ' : ' + fetch_parameter(result.body, 'new-financial-order-state')
      old_state = fetch_parameter(result.body, 'previous-fulfillment-order-state') + ' : ' + fetch_parameter(result.body, 'previous-financial-order-state')
      state     = type + '  -  ' + old_state + '  -  ' + new_state + '  @@@  ' + serial_number

      puts "book_id = #{book_id}, state = #{state}"
      if book_id =~ /\A\d+\z/ && !Book.find_by_id(book_id).nil? # TODO delete when in production
        CommonMailer.deliver_print_order Book.find_by_id(book_id), state
      end
    end


    render :text => params['serial-number']
  end




  def checkout_test
    serial_number = '517669820723894-00005-1'
    puts params

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
    type = fetch_parameter(result.body, '_type')
    if type == 'order-state-change-notification'
      book_id = fetch_parameter(result.body, 'order-summary.shopping-cart.merchant-private-data')

      new_state = fetch_parameter(result.body, 'new-fulfillment-order-state') + ' : ' + fetch_parameter(result.body, 'new-financial-order-state')
      old_state = fetch_parameter(result.body, 'previous-fulfillment-order-state') + ' : ' + fetch_parameter(result.body, 'previous-financial-order-state')
      state = type + '  -  ' + old_state + '  -  ' + new_state + '  @@@  ' + serial_number
      puts "book_id = #{book_id}, state = #{state}"

  #    CommonMailer.deliver_print_order Book.find_by_id(book_id), type
    end

    render :text => result.body
  end

  def db_test
#    result = "start "
#    Attraction.all.each do |a|
#      result += " #{a.city.inspect} <br/>\n"
#    end
#    render :text => result
#    expire_page :controller => "display_controller", :action => "display"
#    render :text => "ok"
    render :xml => "<success/>"
#    render :xml => {:a => 'b'}
#    respond_to do |format|
#      format.xml { 'b' }
#    end
  end

  private

  def fetch_parameter(data, name)
    result = data.scan(/(^|&)#{name}=([^&]*)($|&)/)
    if result.length > 0
      [0][1]
    else
      nil
    end
  end
end
