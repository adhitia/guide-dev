class TipsController < ApplicationController

  def create
    @ajax = true
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
    @ajax = true
    return unless authorize_guide params[:id]
    @full_access = true;

    @calendar = Calendar.find(params[:id])
    params[:tips].each_pair do |id, tip_data|
      tip = Tip.find(id)
      tip.address.update_attributes tip_data[:address]
      tip_data.delete :address
      tip.update_attributes tip_data
    end

    render :text => 'dummy response'
#    if empty?(params[:result])
#    else
#    end
#    render :partial => 'show_tile'
  end

  def follow_url
    @calendar = Calendar.find(params[:id])
    @tip = Tip.find(params[:tip_id])
    @tip.click_count += 1;
    @tip.save;
    @calendar.click_count += 1;
    @calendar.save;
    redirect_to @tip.url
  end

  # removes binding between tip and calendar
  # for now, also removes tip
  def unbind
    @ajax = true
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
    @ajax = true
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
    @ajax = true
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
    @ajax = true
    occurrence = ShowPlace.find(params[:occurrence_id])
    render :partial => 'tips/show', :locals => {:place => occurrence}
  end

  def edit
    @ajax = true
    occurrence = ShowPlace.find(params[:occurrence_id])
    return unless authorize_guide occurrence.calendar_id
    render :partial => 'tips/edit', :locals => {:place => occurrence}
  end

  def tile
    @ajax = true
    occurrence = ShowPlace.find(params[:occurrence_id])
    @full_access = @current_user && (occurrence.calendar.user.id == @current_user.id);
    render :partial => 'tips/show_tile', :locals => {:place => occurrence}
  end

end
