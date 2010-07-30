class TipsController < ApplicationController
  before_filter :login_required, :except => [:follow_url]

  def new
    @tip = Tip.new
    @calendar = Calendar.find(params[:id])
    @tip.condition = Condition.find(params[:condition_id])
    @weekdays = Weekday.all
    @tip.weekdays << Weekday.find(params[:dow]);
    @tip.advertisement = params[:ad] != nil

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tip }
    end
  end


  def edit
    @calendar = Calendar.find(params[:id])
    @tip = Tip.find(params[:tip_id])
    @weekdays = Weekday.all
  end


  def create
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

    render :partial => 'tips/edit_row', :locals => {:place => @place, :label => params[:label]}
  end

  def update
    @calendar = Calendar.find(params[:id])
    params[:tips].each_pair do |id, tip_data|
      tip = Tip.find(id)
      tip.address.update_attributes tip_data[:address]
      tip_data.delete :address
      tip.update_attributes tip_data
    end
    render :text => 'dummy response'
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
  def unbind
    occurrence = ShowPlace.find(params[:occurrence_id])
    occurrence.delete
    occurrence.tip.delete

    render :text => 'dummy response'
  end

  # moves tip to a different place
  def move
    occurrence = ShowPlace.find(params[:occurrence_id])
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
end
