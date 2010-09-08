require 'rubygems'
require 'weather_man'

class CalendarsController < ApplicationController

  before_filter :set_user
  before_filter :ban_ie #, :except => [:display, :vote, :internet_explorer]


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

    @weekdays = Weekday.all
    @conditions = Condition.all

    if (params[:step] == 'overview')
      create_overview
      return
    end

    guide = read_guide
    if guide.invalid?
      @errors = guide.errors_as_hash
      render :action => :new
      return
    end

#    @errors = {};
#    @errors["calendar_name_location"] = "" if params[:calendar_name_location].blank?
#    @errors["calendar_name_target"] = "" if params[:calendar_name_target].blank?
#    @errors["location_code"] = "" if params[:location_code].blank?
#
#    if not @errors.blank?
#      render :action => :new
#      return
#    end

    params['tip_name'] = Hash.new({})

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

    if !params[:location_name].blank?
      @calendar.location_id = find_or_create_location;
    end

    if !params[:access_type].blank?
      @calendar.public = params[:access_type] == "true" ? true : false
    end

    @calendar.save

    render :text => 'dummy response'
  end

#  def change_access_type
#    return unless authorize_guide params[:id]
#
#    @calendar = Calendar.find(params[:id])
#    @new_value = params[:access_type] == "true" ? true : false;
#    @calendar.public = @new_value
#    @calendar.save
#
#    render :text => 'dummy response'
#  end

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
    location = params[:search_location];
    if !location.blank?
      location = location.gsub('%', '\%').gsub('_', '\_')
      @guides = Calendar.find(:all, :conditions=> ["locations.name like ? and public = ?", "%" + location + "%", true], :include=>"location")
    else
      @guides = Calendar.find(:all, :conditions => ["public = ?", true], :include => "location")
    end
  end

  def share
    @calendar = Calendar.find(params[:id])
    @layouts = GuideLayout.find_all_by_public true
  end



  protected


  def create_overview
    Calendar.transaction do
      @calendar = Calendar.new
      @calendar.name_location = params[:calendar_name_location]
      @calendar.name_target = params[:calendar_name_target]
      @calendar.name = @calendar.name_location + ' for ' + @calendar.name_target
#     @calendar.view_count = 0;
#     @calendar.click_count = 0;
      @calendar.user = @current_user

      @calendar.location_id = find_or_create_location

      @calendar.save

      @errors = {}
      Condition.all.each do |c|
        Weekday.all.each do |day|
          name = params['tip_name'][c.id.to_s][day.id.to_s];
          param_name = "tip_name[#{c.id}][#{day.id}]";
          if !empty?(name)
            tip = Tip.new
            tip.name = name
            tip.author_id = @current_user.id
            if tip.invalid?
#              puts "!!!!!!!!!!!!! #{tip.errors_as_hash.inspect} ! #{tip.phone.nil?} ! #{tip.url.nil?} !"
#              puts "!!!!!!!!!!!!! #{tip.errors.on :phone} !"
              @errors[param_name] = tip.errors.on :name
              next
            end

            tip.address = Address.new :address => '', :lat => 0, :lng => 0, :location => @calendar.location, :tip => tip
            tip.save

            where = ShowPlace.new
            where.condition = c
            where.weekday = day
            where.calendar = @calendar
            where.tip = tip
            where.save
          end
        end
      end

      if !@errors.empty?
#        puts "!!!!!!!!!!!!!! #{@errors.inspect}"
        render :action => :new_overview
        raise ActiveRecord::Rollback
      else
        redirect_to :action => :edit, :id => @calendar.id
      end
    end

  end


  def find_or_create_location(location_code = params[:location_code], location_name = params[:location_name])
    return nil if location_code.blank?

    location = Location.find_by_code location_code
    if location == nil
      Location.create(:name => location_name, :code => location_code)
      location = Location.find_by_code location_code
    end
    location.id
  end

  def read_guide
    Calendar.new({
            :name_location => params[:calendar_name_location],
            :name_target => params[:calendar_name_target],
#            :location_id => find_or_create_location(params[:location_code], params[:location_name])
            :location_id => find_or_create_location
    })
  end
end


