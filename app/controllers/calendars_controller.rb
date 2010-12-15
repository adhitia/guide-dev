require 'rubygems'
require 'weather_man'
require 'prawn'
require "open-uri"


class CalendarsController < ApplicationController
  before_filter :ban_ie


  def show
    @guide = verify_guide params[:id]
    @full_access = @current_user && (@guide.user.id == @current_user.id)

    @today = Date.today.cwday - 1
#    @weekdays = Weekday.all
    @conditions = @guide.conditions

    if @full_access
      render :action => 'edit'
    else
      render :action => 'show'
    end
  end

  def new
    authenticate
  end

  def create
    authenticate

#    @weekdays = Weekday.all
    @conditions = Condition.all

#    if (params[:step] == 'list-places')
#      create_list
#      return
#    elsif (params[:step] == 'overview')
#      create_overview
#      return
#    end

    guide = read_guide
    guide.guide_type_id = 1
    guide.name = guide.name_location + ' for ' + guide.name_target

    if guide.invalid?
      @errors = guide.errors_as_hash(false)
      if (!@errors['location_id'].nil?)
        @errors['location_id'] = nil
        @errors['location_name'] = 'required field' 
      end
      render :action => :new
      return
    end

    guide.public = true
    guide.save

#    @calendar = Calendar.new
#    @calendar.name_location = params[:calendar_name_location]
#    @calendar.name_target = params[:calendar_name_target]
#    @calendar.user = @current_user
#    @calendar.guide_type = GuideType.find params[:guide_type_id]
#    @calendar.location_id = find_or_create_location

#    params['tip_name'] = Hash.new({})

#    render :action => :new_overview
    redirect_to :action => :show, :id => guide.id
  end



  def edit
    @calendar = authorize_guide params[:id]
    @weekdays = Weekday.all
    @conditions = @calendar.conditions
  end

  def update
    @guide = authorize_guide params[:id]

    @guide.location_id = find_or_create_location

    @guide.update_attributes params[:calendar]

    if @guide.invalid?
      @errors = @guide.errors_as_hash
      @errors = flatten({:calendar => @errors})

      render :text => {:errors => @errors}.to_json
      return
    end

    @guide.save

    render :partial => 'edit_pane', :locals => {:guide => @guide}
  end

  def update_matrix
    @guide = authorize_guide params[:id]

    Tip.transaction do
#      p "!!!!!!!!!!!"
#      p params[:data]
      if params[:data].blank?
        params[:data] = {}
      end
      params[:data].each_pair do |day, condition_data|
        condition_data.each_pair do |condition_id, tip_ids|
          tip_ids.each_index do |tip_index|
            tip = Tip.find tip_ids[tip_index]
            if tip.calendar_id != @guide.id
              raise "Found tip belonging to guide #{tip.calendar_id}, while #{@guide.id} expected."
            end

            tip.rank = tip_index
            tip.condition_id = condition_id
            tip.day = day
            tip.save
          end
        end
      end
    end

    render :text => 'dummy response'
  end
  
  def search
    location = params[:search_location]
    if !location.blank?
      location = location.gsub('%', '\%').gsub('_', '\_')
      @guides = Calendar.find(
              :all,
              :conditions => ["LOWER(locations.name) like ? and public = ?", "%" + location.downcase + "%", true],
              :include => "location",
              :order => 'rating DESC'
      )
      @cities = Location.find(:all, :conditions => ["LOWER(name) like ?", "%" + location.downcase + "%"])
    else
      @guides = Calendar.find(:all, :conditions => ["public = ?", true], :include => "location")
      @cities = Location.find(:all)
    end

    @cities.reject! {|a| a.guides.length == 0}
    @cities.sort! {|a, b| b.guides.length <=> a.guides.length}
  end

  def share
    @calendar = verify_guide params[:id]
    @layouts = GuideLayout.find_all_by_public true
  end

  def map
    @guide = verify_guide params[:id]
  end

  def print
    @guide = verify_guide params[:id]
    @book = Book.find_by_calendar_id @guide.id, :order => 'created_at DESC', :limit => 1
    if @book.nil?
      @book = Book.new(:calendar_id => @guide.id)
      @book.save
    end

    @book.sync_tips
  end

  def city_map
    @city = verify_resource params[:id], Location, 'City'
#     and completed_percentage > 10
    @guides = Calendar.find(:all, :conditions => ['location_id = ? and public = ?', @city.id, true], :order => 'rating DESC')
    @attractions = Attraction.find(:all, :conditions => ['city_id = ? and popularity > 0', @city.id], :order => 'popularity DESC', :limit => 50)
  end

  protected

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
            :name_location => params[:name_location],
            :name_target => params[:name_target],
            :location_id => find_or_create_location,
            :user_id => @current_user.id
    })
  end
end


