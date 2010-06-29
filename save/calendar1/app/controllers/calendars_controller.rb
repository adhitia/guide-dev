require 'rubygems'
require 'weather_man'
require 'calendars_helper'

class CalendarsController < ApplicationController
  before_filter :login_required, :only => [:advertise, :advertise_choose, :new, :edit]

  def index
    @calendars = Calendar.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @calendar = Calendar.find(params[:id])
    @today = Date.today.cwday - 1;

    respond_to do |format|
      format.html
    end
  end

  def new
    @calendar = Calendar.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @calendar = Calendar.find(params[:id])
    @weekdays = Weekday.all
    @conditions = Condition.all
  end

  def create
    @calendar = Calendar.new(params[:calendar])
    @calendar.view_count = 0;
    @calendar.click_count = 0;
    @calendar.user = @current_user

    location_code = params[:location_code]
    location_name = params[:location_name]
    loc = Location.find_by_code location_code
    if loc == nil
      Location.create(:name => location_name, :code => location_code)
      loc = Location.find_by_code location_code
    end
    @calendar.location_id = loc.id;

    if location_code == ''
      flash[:error] = 'Please select location.';
      render :action => "new"
      return
    end
    

    respond_to do |format|
      if @calendar.save
        flash[:notice] = 'Calendar was successfully created.'
        format.html { redirect_to(@calendar) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @calendar = Calendar.find(params[:id])
    location_code = params[:location_code]
    location_name = params[:location_name]
    loc = Location.find_by_code location_code
    if loc == nil
      Location.create(:name => location_name, :code => location_code)
      loc = Location.find_by_code location_code
    end
    @calendar.location_id = loc.id;

    if location_code == ''
      flash[:error] = 'Please select location.';
      render :action => "edit"
      return
    end

    respond_to do |format|
      if @calendar.update_attributes(params[:calendar])
        flash[:notice] = 'Calendar was successfully updated.'
        format.html { redirect_to(@calendar) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy

    respond_to do |format|
      format.html { redirect_to(calendars_url) }
      format.xml  { head :ok }
    end
  end


  def advertise_choose
    @calendar = Calendar.find(params[:id])
    @ads = Advertisement.find_all_by_calendar_id params[:id]
    puts @ads.length
    @weekdays = Weekday.all
    @conditions = Condition.all
  end

  def advertise
    @calendar = Calendar.find(params[:id])
    Condition.all.each do |condition|
      p = params["condition_" + condition.id.to_s];
      puts p
      if p != nil
        Weekday.all.each do |day|
          if (p.index('all') || p.index(day.id.to_s))
            ad = Advertisement.new
            ad.weekday = day;
            ad.condition = condition;
            ad.calendar = @calendar; 
            ad.user = @current_user;
            ad.views_total = 0;
            ad.views_paid = 1000;
            if !ad.save
              respond_to do |format|
                flash[:notice] = 'Unable to book ads.'
                format.html { render :action => "advertise_choose" }
              end
              return
            end
          end
        end
      end
    end
  end

  def ads
    @calendar = Calendar.find(params[:id])
    @weekdays = Weekday.all
    @conditions = Condition.all
    @ads = Advertisement.find_all_by_calendar_id_and_user_id params[:id], @current_user.id
  end

  def search
    if (params[:search_location] == 'type destination here')
      params[:search_location] = '';
    end
    location = params[:search_location];
    if location && location != ''
      location = location.gsub('%', '\%').gsub('_', '\_')
      @calendars = Calendar.find(:all, :conditions=> ["locations.name like ?", "%" + location + "%"], :include=>"location")
    else
      @calendars = Calendar.find(:all, :include=>"location")
    end
  end

end


