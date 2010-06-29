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
    @tip = Tip.new(params[:tip])
    @tip.calendar = @calendar
    @tip.view_count = 0
    @tip.click_count = 0
    @tip.author_id= @current_user.id;

    @tip.address = Address.new :address => params[:address], :lat => params[:address_lat], :lng => params[:address_lng],
                              :location_id => @calendar.location_id, :tip_id => @tip.id

    respond_to do |format|
      if @tip.save
        flash[:notice] = 'Tip was successfully created.'
        if @tip.advertisement
          format.html { redirect_to(:controller => :calendars, :action => :ads, :id => @calendar) }
        else
          format.html { redirect_to(edit_calendar_path :id => @calendar.id) }
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @calendar = Calendar.find(params[:id])
    @tip = Tip.find(params[:tip_id])
    @weekdays = Weekday.all
    @tip.address.address = params[:address]
    @tip.address.lat = params[:address_lat]
    @tip.address.lng = params[:address_lng]
    @tip.address.save

    respond_to do |format|
      if @tip.update_attributes(params[:tip])
        flash[:notice] = 'Tip was successfully updated.'
        format.html { redirect_to(edit_calendar_path :id => @calendar.id) }
      else
        format.html { render :action => "edit" }
      end
    end
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

end
