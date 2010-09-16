require 'rubygems'
require 'weather_man'

class CalendarsController < ApplicationController
#  before_filter :set_user
  before_filter :ban_ie #, :except => [:display, :vote, :internet_explorer]


  def show
    @calendar = verify_guide params[:id]
    return if @calendar.nil?
    @full_access = @current_user && (@calendar.user.id == @current_user.id);

    @today = Date.today.cwday - 1;
    @weekdays = Weekday.all
    @conditions = Condition.all
  end

  def new
    return unless authenticate
  end

  def edit_day
    return unless authorize_guide params[:id]

    @calendar = Calendar.find(params[:id])
    @edit_for = Weekday.find params[:weekday_id]
    @weekdays = Weekday.all
    @conditions = Condition.all

#    @tips = @calendar.show_places.
#            reject { |t| t.weekday.id != @edit_for.id }
#    @conditions.each do |c|
#      if !@tips.detect {|t| t.condition.id == c.id}
#        @tips.push ShowPlace.new
#      end
#    end
#            sort_by { |t| t.condition.id}



#    render :partial => 'edit_tab'
    render :partial => 'edit_day'
  end

  def edit_condition
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
  
  def search
    location = params[:search_location];
    if !location.blank?
      location = location.gsub('%', '\%').gsub('_', '\_')
      @guides = Calendar.find(
              :all,
              :conditions=> ["LOWER(locations.name) like ? and public = ?", "%" + location.downcase + "%", true],
              :include=>"location"
      )
    else
      @guides = Calendar.find(:all, :conditions => ["public = ?", true], :include => "location")
    end
  end

  def share
    @calendar = verify_guide params[:id]
    return if @calendar.nil?
    @layouts = GuideLayout.find_all_by_public true
  end



  protected


  def create_overview
    Calendar.transaction do
      @calendar = Calendar.new
      @calendar.name_location = params[:calendar_name_location]
      @calendar.name_target = params[:calendar_name_target]
      @calendar.name = @calendar.name_location + ' for ' + @calendar.name_target
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
        render :action => :new_overview
        raise ActiveRecord::Rollback
      else
        redirect_to :action => :edit, :id => @calendar.id
      end
    end

  end


  def find_or_create_location(location_code = params[:location_code], location_name = params[:location_name])
    return nil if location_code.blank? || location_name.blank?

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
            :location_id => find_or_create_location
    })
  end
end


