class TipsController < ApplicationController
  before_filter :ban_ie #, :except => [:display, :vote, :internet_explorer]

  def create
    return unless authorize_guide params[:id]
    @full_access = true

    @calendar = Calendar.find(params[:id])
    @tip = Tip.new(:name => params[:new_tip_name])
    @tip.author_id= @current_user.id;
    @tip.address = Address.new :address => '', :lat => 0, :lng => 0, :location_id => @calendar.location_id,
                               :tip_id => @tip.id

    @place = ShowPlace.new;
    @place.condition_id = params[:condition_id]
    @place.weekday_id = params[:weekday_id]
    @place.calendar = @calendar
    @place.tip = @tip

    @tip.save
    @place.save

    render :partial => "tips/#{params[:result]}", :locals => {:place => @place, :label => params[:label]}
#    render :partial => "tips/edit", :locals => {:place => @place}
  end

  def update
    return unless authorize_guide params[:id]
    @full_access = true;

    @calendar = Calendar.find(params[:id])
    errors = {};

    Tip.transaction do
      params[:tips].each_pair do |id, tip_data|
        tip = Tip.find id, :lock => true
        if tip.author_id != @calendar.user_id
          raise "Found tip belonging to user #{tip.author_id}, while #{@calendar.user_id} expected."
        end

        tip.address.update_attributes tip_data[:address]
        tip_data.delete :address
        tip.update_attributes tip_data

        errors["tips[#{id}]"] = tip.errors_as_hash
      end


      
      errors = flatten errors 
      if !errors.empty?
        puts "!!!!!!!!!!!!!! #{errors.inspect}"
        raise ActiveRecord::Rollback
      end
    end

    render :text => {:errors => errors}.to_json
#    render :json => {}
#    render :json => errors
#    render :text => 'dummy response'
  end

  def follow_url
    @calendar = Calendar.find(params[:id])
    @tip = Tip.find(params[:tip_id])
    @tip.click_count += 1;
    @tip.save;
    @calendar.click_count += 1;
    @calendar.save;

    url = @tip.url
    if !url.start_with? 'http://'
      url = 'http://' + url
    end
    redirect_to url
  end

  # removes binding between tip and calendar
  # for now, also removes tip
  def unbind
    occurrence = ShowPlace.find(params[:occurrence_id])
    return unless authorize_guide occurrence.calendar_id
    @full_access = true

    occurrence.delete
    occurrence.tip.delete

#    render :text => 'dummy response'
    render :partial => 'tips/no_tip_tile', :locals => {:condition => occurrence.condition, :day => occurrence.weekday}
  end

  # moves tip to a different place
  def move
    occurrence = ShowPlace.find(params[:occurrence_id])
    return unless authorize_guide occurrence.calendar_id

    condition = Condition.find(params[:condition_id])
    weekday = Weekday.find(params[:weekday_id])
    occurrence.condition = condition
    occurrence.weekday = weekday
    occurrence.save

    render :text => 'dummy response'
  end

  # switches two tips in one calendar
  def switch
    occurrence = ShowPlace.find(params[:occurrence_id])
    return unless authorize_guide occurrence.calendar_id

    target = ShowPlace.find(params[:target_id])

    # switch weekday and condition
    weekday = occurrence.weekday
    condition = occurrence.condition
    occurrence.weekday = target.weekday
    occurrence.condition = target.condition
    target.weekday = weekday
    target.condition = condition

    occurrence.save
    target.save

    render :text => 'dummy response'
  end

  def show
    occurrence = ShowPlace.find(params[:occurrence_id])
    render :partial => 'tips/show', :locals => {:place => occurrence}
  end

  def edit
    occurrence = ShowPlace.find(params[:occurrence_id])
    return unless authorize_guide occurrence.calendar_id
    render :partial => 'tips/edit', :locals => {:place => occurrence}
  end

  def tile
    occurrence = ShowPlace.find(params[:occurrence_id])
    @full_access = @current_user && (occurrence.calendar.user.id == @current_user.id);
    render :partial => 'tips/show_tile', :locals => {:place => occurrence}
  end

end
