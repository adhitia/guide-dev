require 'rubygems'
require 'weather_man'
require 'calendars_helper'

class CalendarsController < ApplicationController

  def show
    @calendar = Calendar.find(params[:id])
    @full_access = @current_user && (@calendar.user.id == @current_user.id);

    @today = Date.today.cwday - 1;
    @weekdays = Weekday.all
    @conditions = Condition.all
  end

  def new
    return unless authenticate
  end

  def edit_day
    @ajax = true
    return unless authorize_guide params[:id]

    @calendar = Calendar.find(params[:id])
    @edit_for = Weekday.find params[:weekday_id]
    @weekdays = Weekday.all
    @conditions = Condition.all

    render :partial => 'edit_day'
  end

  def edit_condition
    @ajax = true
    return unless authorize_guide params[:id]

    @calendar = Calendar.find(params[:id])
    @edit_for = Condition.find params[:condition_id]
    @weekdays = Weekday.all
    @conditions = Condition.all

    render :partial => 'edit_condition'
  end

  def create
    return unless authenticate

    if (params[:step] == 'overview')
      create_overview
      return
    end


#    puts "!!!!!!!!!!!!! #{params[:location_code]} : #{params[:location_name]}"

    # validate data
    if (empty?(params[:calendar_name_location]) || empty?(params[:calendar_name_target]))
      flash[:error] = 'Please select name.';
      render :action => :new
      return
    end
    if (empty? params[:location_code])
      flash[:error] = 'Please select location.';
      render :action => :new
      return
    end


    @weekdays = Weekday.all
    @conditions = Condition.all

    render :action => :new_overview
  end



  def edit
    return unless authorize_guide params[:id]

    @calendar = Calendar.find(params[:id])
    @weekdays = Weekday.all
    @conditions = Condition.all
  end

  def update
    @ajax = true
    return unless authorize_guide params[:id]

    @calendar = Calendar.find(params[:id])

    location_code = params[:location_code]
    location_name = params[:location_name]

    if not empty? params[:location_name]
      loc = find_or_create_location location_code, location_name
      @calendar.location_id = loc.id;
      @calendar.save
    end

    render :text => 'dummy response'
  end

#  def update
#    @calendar = Calendar.find(params[:id])
#    location_code = params[:location_code]
#    location_name = params[:location_name]
#    loc = find_or_create_location location_code, location_name
#    @calendar.location_id = loc.id;
#
#    if location_code == ''
#      flash[:error] = 'Please select location.';
#      render :action => "edit"
#      return
#    end
#
#    respond_to do |format|
#      if @calendar.update_attributes(params[:calendar])
#        flash[:notice] = 'Calendar was successfully updated.'
#        format.html { redirect_to(@calendar) }
#      else
#        format.html { render :action => "edit" }
#      end
#    end
#  end

#
#  def advertise_choose
#    @calendar = Calendar.find(params[:id])
#    @ads = Advertisement.find_all_by_calendar_id params[:id]
#    puts @ads.length
#    @weekdays = Weekday.all
#    @conditions = Condition.all
#  end
#
#  def advertise
#    @calendar = Calendar.find(params[:id])
#    Condition.all.each do |condition|
#      p = params["condition_" + condition.id.to_s];
#      puts p
#      if p != nil
#        Weekday.all.each do |day|
#          if (p.index('all') || p.index(day.id.to_s))
#            ad = Advertisement.new
#            ad.weekday = day;
#            ad.condition = condition;
#            ad.calendar = @calendar;
#            ad.user = @current_user;
#            ad.views_total = 0;
#            ad.views_paid = 1000;
#            if !ad.save
#              respond_to do |format|
#                flash[:notice] = 'Unable to book ads.'
#                format.html { render :action => "advertise_choose" }
#              end
#              return
#            end
#          end
#        end
#      end
#    end
#  end
#
#  def ads
#    @calendar = Calendar.find(params[:id])
#    @weekdays = Weekday.all
#    @conditions = Condition.all
#    @ads = Advertisement.find_all_by_calendar_id_and_user_id params[:id], @current_user.id
#  end

  def search
#    if (params[:search_location] == 'type destination here')
#      params[:search_location] = '';
#    end
    location = params[:search_location];
    if location && location != ''
      location = location.gsub('%', '\%').gsub('_', '\_')
      @guides = Calendar.find(:all, :conditions=> ["locations.name like ?", "%" + location + "%"],
                                  :include=>"location")
    else
      @guides = Calendar.find(:all, :include=>"location")
    end
  end

  def share
    @calendar = Calendar.find(params[:id])
  end



  protected


  def create_overview
    @calendar = Calendar.new
    @calendar.name_location = params[:calendar_name_location]
    @calendar.name_target = params[:calendar_name_target]
    @calendar.name = @calendar.name_location + ' for ' + @calendar.name_target
    @calendar.view_count = 0;
    @calendar.click_count = 0;
    @calendar.user = @current_user

    location_code = params[:location_code]
    location_name = params[:location_name]
    location = find_or_create_location location_code, location_name
    @location_id = location.id
    @calendar.location_id = location.id

    @calendar.save

    Condition.all.each do |c|
      Weekday.all.each do |day|
        name = params['tip_name'][c.id.to_s][day.id.to_s];
        if !empty?(name)
          tip = Tip.new
          tip.name = name
          tip.author_id = @current_user.id
          tip.save

          tip.address = Address.new :address => '', :lat => 0, :lng => 0, :location => @calendar.location, :tip => tip

          where = ShowPlace.new
          where.condition = c
          where.weekday = day
          where.calendar = @calendar
          where.tip = tip
          where.save
        end
      end
    end

    redirect_to :action => :edit, :id => @calendar.id
  end


  def find_or_create_location(location_code, location_name)
    location = Location.find_by_code location_code
    if location == nil
      Location.create(:name => location_name, :code => location_code)
      location = Location.find_by_code location_code
    end
    location
  end

end


