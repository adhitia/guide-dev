class TipsController < ApplicationController
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

    render :partial => 'tips/edit_row', :locals => {:place => @place}
  end

  def update
    @calendar = Calendar.find(params[:id])
    params[:tips].each_pair do |id, tip_data|
      tip = Tip.find(id)
      tip.address.update_attributes tip_data[:address]
      tip_data.delete :address
      tip.update_attributes tip_data
    end
#    render :nothing => true
    render :text => 'dummy response'
  end
#
#  def update
#    @calendar = Calendar.find(params[:id])
#    @tip = Tip.find(params[:tip_id])
#    @weekdays = Weekday.all
#    @tip.address.address = params[:address]
#    @tip.address.lat = params[:address_lat]
#    @tip.address.lng = params[:address_lng]
#    @tip.address.save
#
#    respond_to do |format|
#      if @tip.update_attributes(params[:tip])
#        flash[:notice] = 'Tip was successfully updated.'
#        format.html { redirect_to(edit_calendar_path :id => @calendar.id) }
#      else
#        format.html { render :action => "edit" }
#      end
#    end
#  end

  def follow_url
    @calendar = Calendar.find(params[:id])
    @tip = Tip.find(params[:tip_id])
    @tip.click_count += 1;
    @tip.save;
    @calendar.click_count += 1;
    @calendar.save;
    redirect_to @tip.url
  end

end
