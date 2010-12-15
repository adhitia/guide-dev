class TipsController < ApplicationController
  before_filter :ban_ie #, :except => [:display, :vote, :internet_explorer]

  def create
    @guide = authorize_guide params[:id]
    @full_access = true

    tip_data = params[:tip]
    attraction = find_or_create_attraction tip_data[:attraction]
    tip_data.delete :attraction

    tip = Tip.new tip_data
    tip.attraction_id = attraction.id if !attraction.nil?

    # seek for first empty spot
    tips = @guide.grouped_tips
    found = false
    for day in (0..DAY_LIMIT - 1)
      if day == tips.length
        tip.condition_id = @guide.conditions[0].id
        tip.day = day
        found = true
        break
      end

      @guide.conditions.each do |condition|
        if tips[day][condition.id].length == 0
          tip.condition_id = condition.id
          tip.day = day
          found = true
          break
        end
      end
      if found
        break
      end
    end

    # no empty spots
    if not found
      tip.condition_id = @guide.conditions[0].id
      tip.day = 0
    end

    tip.calendar_id = @guide.id
    tip.author_id = @current_user.id
    tip.save!

    if !attraction.nil?
      attraction.popularity += 1
      attraction.save!
    end

    @guide.update_completed_percentage
    @guide.save!

    render :partial => 'edit_tile', :locals => {:tip => tip}
  end

  def new
    @calendar = authorize_guide params[:id]
    @full_access = true

    tip = Tip.new(
            :attraction => Attraction.new,
            :calendar => @calendar,
            :condition => Condition.find(params[:condition_id]),
            :weekday => Weekday.find(params[:weekday_id])
    )
    render :partial => "tips/edit", :locals => {:tip => tip}
  end

  def update
    @guide = authorize_guide params[:id]
#    @full_access = true;

    @errors = {}
#    new_tip_id = nil

    tip_data = params[:tip]
    p "id !!!!!!!!!!!! #{tip_data[:id]}"
    tip = Tip.find tip_data[:id], :lock => true

    Tip.transaction do
      attraction = find_or_create_attraction tip_data[:attraction]
      if attraction.id != tip.attraction_id
        tip.attraction.popularity -= 1 if !tip.attraction.nil?
        attraction.popularity += 1
        tip.attraction.save!
        attraction.save!

        tip.attraction = attraction
      end
      tip_data.delete :attraction

      tip.update_attributes tip_data
      tip.save

      p "errors????????????"
      p tip.errors

#      @errors["tips[#{id}]"] = tip.errors_as_hash
      @errors["tips"] = tip.errors_as_hash

      @errors = flatten @errors
      if !@errors.empty?
        raise ActiveRecord::Rollback.new
      end

      @guide.update_completed_percentage
      @guide.save
    end

    if !@errors.empty?
#      render :text => {:errors => @errors}.to_json
#      return
      raise "validation errors present: #{@errors.inspect}"
    end


#    render :text => {:errors => @errors, :new_tip_id => new_tip_id}.to_json
    render :partial => 'edit_tile', :locals => {:tip => tip}
  end

  def follow_url
    @calendar = verify_guide params[:id]
    @tip = verify_tip params[:tip_id]

    @tip.click_count += 1
    @tip.save
    @calendar.click_count += 1
    @calendar.save

    url = @tip.url
    if !url.start_with? 'http://'
      url = 'http://' + url
    end
    redirect_to url
  end

  # removes the tip
  def delete
    tip = verify_tip params[:id]
    authorize_guide tip.calendar_id

    tip.destroy

    tip.calendar.update_completed_percentage
    tip.calendar.save

    render :text => 'dummy response'
  end

  # moves tip to a different place
  def move
    tip = verify_tip params[:occurrence_id]
    authorize_guide tip.calendar_id

#    tip.condition = Condition.find(params[:condition_id])
#    tip.weekday = Weekday.find(params[:weekday_id])
    tip.condition_id = params[:condition_id]
    tip.weekday_id = params[:weekday_id]
    tip.save

    render :text => 'dummy response'
  end

  # switches two tips in one calendar
  def switch
    tip = verify_tip params[:occurrence_id]
    authorize_guide tip.calendar_id

    target = Tip.find(params[:target_id])

    # switch weekday and condition
    weekday = tip.weekday_id
    condition = tip.condition_id
    tip.weekday_id = target.weekday_id
    tip.condition_id = target.condition_id
    target.weekday_id = weekday
    target.condition_id = condition

    tip.save
    target.save

    render :text => 'dummy response'
  end

  def show
    tip = verify_tip params[:occurrence_id]
    render :partial => 'tips/show', :locals => {:tip => tip}
  end

  def edit
    tip = verify_tip params[:occurrence_id]
    authorize_guide tip.calendar_id
    render :partial => 'tips/edit', :locals => {:tip => tip}
  end

  def tile
    tip = verify_tip params[:occurrence_id]
    @full_access = @current_user && (tip.calendar.user.id == @current_user.id);
    render :partial => 'tips/show_tile', :locals => {:tip => tip}
  end

  private

  def find_or_create_attraction(data)
    return nil if data[:identity_url].nil?
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!! #{data.inspect}"

    attraction = Attraction.find_by_identity_url data[:identity_url]
    if attraction.nil?

      # hack because fucking rails
#      lat = Float(data[:lat])
#      lng = Float(data[:lng])
#      puts "********** #{lat} : #{lng}"
      attraction = Attraction.find(:first, :conditions => ["lat = ? and lng = ?", Float(data[:lat]), Float(data[:lng])])
#      def dist(a)
#        (lat - a.lat).abs + (lng - a.lng).abs
#      end
#      attraction = Attraction.all.min {|a, b| dist(a) <=> dist(b)}
#      if (dist(attraction) > 0.0001)
#        attraction = nil
#      end

      puts "!!!!!!!!!!! found old ? #{attraction.inspect}"
      if !attraction.nil?
        if attraction.identity_url.start_with? 'placeholder_for_tip_'
          attraction.identity_url = data[:identity_url]
          attraction.save!
        else
          attraction = nil
        end
      end

      if attraction.nil?
        data[:city_id] = @guide.location_id
        attraction = Attraction.create(data)
      end
    end
    attraction
  end
end
