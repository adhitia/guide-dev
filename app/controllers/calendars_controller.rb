require 'rubygems'
require 'weather_man'

class CalendarsController < ApplicationController
  before_filter :ban_ie


  def show
    @calendar = verify_guide params[:id]
    @full_access = @current_user && (@calendar.user.id == @current_user.id);

    @today = Date.today.cwday - 1;
    @weekdays = Weekday.all
    @conditions = @calendar.conditions
  end

  def new
    authenticate
  end

  def edit_day
    @calendar = authorize_guide params[:id]
    @edit_for = Weekday.find params[:weekday_id]
    @edit_prev = Weekday.find_by_id(@edit_for.id - 1)  
    @edit_next = Weekday.find_by_id(@edit_for.id + 1)

    @tips = @calendar.tips.reject { |t| t.weekday.id != @edit_for.id }
    @calendar.conditions.each do |c|
      if !@tips.detect {|t| t.condition.id == c.id}
        @tips.push Tip.new(
                :address => Address.new,
                :calendar => @calendar,
                :condition => c,
                :weekday => @edit_for
        )
      end
    end
    @tips = @tips.sort_by {|t| t.condition.id}
    @labels = @tips.map {|t| t.condition.full_name }

    render :partial => 'edit_tab'
  end

  def edit_condition
    @calendar = authorize_guide params[:id]
    @edit_for = Condition.find params[:condition_id]
    @edit_prev = @calendar.conditions.find_by_id(@edit_for.id - 1)  
    @edit_next = @calendar.conditions.find_by_id(@edit_for.id + 1)

    @tips = @calendar.tips.reject { |t| t.condition.id != @edit_for.id }
    Weekday.all.each do |day|
      if !@tips.detect {|t| t.weekday.id == day.id}
        @tips.push Tip.new(
                :address => Address.new,
                :calendar => @calendar,
                :weekday => day,
                :condition => @edit_for
        )
      end
    end
    @tips = @tips.sort_by {|t| t.weekday.id}
    @labels = @tips.map {|t| t.weekday.name }

    render :partial => 'edit_tab'
  end

  def create
    authenticate

    @weekdays = Weekday.all
    @conditions = Condition.all

    if (params[:step] == 'list-places')
      create_list
      return
    elsif (params[:step] == 'overview')
      create_overview
      return
    end

    guide = read_guide
    guide.guide_type_id = 1
    if guide.invalid?
      @errors = guide.errors_as_hash
      render :action => :new
      return
    end

    params['tip_name'] = Hash.new({})

#    render :action => :new_overview
    render :action => :new_places
  end



  def edit
    @calendar = authorize_guide params[:id]
    @weekdays = Weekday.all
    @conditions = @calendar.conditions
  end

  def update
    @calendar = authorize_guide params[:id]

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
    @layouts = GuideLayout.find_all_by_public true
  end

  def map
    @guide = verify_guide params[:id]
  end



  protected


  def create_overview
    Calendar.transaction do
      @calendar = Calendar.new
      @calendar.name_location = params[:calendar_name_location]
      @calendar.name_target = params[:calendar_name_target]
      @calendar.name = @calendar.name_location + ' for ' + @calendar.name_target
      @calendar.user = @current_user
      @calendar.guide_type = GuideType.find params[:guide_type_id]

      @calendar.location_id = find_or_create_location

      @calendar.save

      @errors = {}
      Condition.all.each do |c|
        if !params['tip_name'] || !params['tip_name'][c.id.to_s]
          next
        end
        Weekday.all.each do |day|
          if !params['tip_name'][c.id.to_s][day.id.to_s]
            next
          end
          name = params['tip_name'][c.id.to_s][day.id.to_s];
          param_name = "tip_name[#{c.id}][#{day.id}]";
#          if !empty?(name)
            tip = Tip.new
            tip.name = name
            tip.author_id = @current_user.id

            tip.address = Address.new :address => '', :location => @calendar.location, :tip => tip
            tip.condition_id = c.id
            tip.weekday_id = day.id
            tip.calendar_id = @calendar.id

#            if tip.invalid?
#              @errors[param_name] = tip.errors.on :name
#              next
#            end

            tip.save
#          end
        end
      end

#      if !@errors.empty?
#        render :action => :new_overview
#        raise ActiveRecord::Rollback
#      else
        redirect_to :action => :edit, :id => @calendar.id
#      end
    end
  end


  def create_list
    @places = read_places(params['day-places']) + read_places(params['dinner-places']) + read_places(params['night-places'])

    params['tip_name'] = Hash.new({})
    render :action => :new_overview2
  end

  def read_places(text)
    text.scan(/^\s*(\S.*)\s*$/).map {|c| c[0].strip[0, 25] }
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
            :location_id => find_or_create_location,
            :user_id => @current_user.id
    })
  end
end


