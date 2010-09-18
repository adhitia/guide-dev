class TipsController < ApplicationController
  before_filter :ban_ie #, :except => [:display, :vote, :internet_explorer]

  def create
    return unless authorize_guide params[:id]
    @full_access = true

    @calendar = Calendar.find(params[:id])

    @tip = Tip.new(:name => params[:new_tip_name])
    @tip.author_id= @current_user.id;
    @tip.address = Address.new :address => '', :location_id => @calendar.location_id,
                               :tip_id => @tip.id

    @tip.condition_id = params[:condition_id]
    @tip.weekday_id = params[:weekday_id]
    @tip.calendar = @calendar

    @tip.save

    render :partial => "tips/#{params[:result]}", :locals => {:tip => @tip}
  end

  def new
    return unless authorize_guide params[:id]
    @full_access = true

    @calendar = Calendar.find(params[:id])
    tip = Tip.new(
            :address => Address.new,
            :calendar => @calendar,
            :condition => Condition.find(params[:condition_id]),
            :weekday => Weekday.find(params[:weekday_id])
    )
    render :partial => "tips/edit", :locals => {:tip => tip}
  end

  def update
    return unless authorize_guide params[:id]
    @full_access = true;

    @calendar = Calendar.find(params[:id])
    @errors = {};
    new_tip_id = nil

    Tip.transaction do
      if !params[:tips].nil?
        params[:tips].each_pair do |id, tip_data|
          tip = Tip.find id, :lock => true
          if tip.author_id != @calendar.user_id
            raise "Found tip belonging to user #{tip.author_id}, while #{@calendar.user_id} expected."
          end

#        if !tip_data[:name].blank?
          tip.address.update_attributes tip_data[:address]
          tip_data.delete :address
          tip.update_attributes tip_data
          @errors["tips[#{id}]"] = tip.errors_as_hash
#        else
#          tip.delete
#        end
        end
      end

#      puts "!!!!!!!!!!!!!! require tip ?#{params[:require_tip]}?"

      if !params[:tips_new].nil?
        params[:tips_new].each_pair do |condition_id, weekday_map|
          weekday_map.each_pair do |weekday_id, tip_data|
#            puts "!!!!!!!!!!!  "
            if tip_data[:name].blank? && params[:require_tip].blank?
              next
            end
#            if !tip_data[:name].blank?
              address = Address.new tip_data[:address]
              tip_data.delete :address

              tip = Tip.new tip_data
              tip.address = address
              tip.condition_id = condition_id
              tip.weekday_id = weekday_id
              tip.calendar_id = @calendar.id
              tip.author_id = @current_user.id
              tip.save

              new_tip_id = tip.id

              @errors["tips_new[#{condition_id}][#{weekday_id}]"] = tip.errors_as_hash
#              puts "!!!!!!!!!!!!!!!! new tip!\n #{tip.inspect} "
#            end
          end
        end
      end

      @errors = flatten @errors
      if !@errors.empty?
        raise ActiveRecord::Rollback.new
      end
    end

    render :text => {:errors => @errors, :new_tip_id => new_tip_id}.to_json
  end

  def follow_url
    @calendar = verify_guide params[:id]
    return if @calendar.nil?
    @tip = verify_tip params[:tip_id]
    return if @tip.nil?

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
    tip = Tip.find(params[:occurrence_id])
    return unless authorize_guide tip.calendar_id
    @full_access = true

    tip.delete

    render :partial => 'tips/no_tip_tile', :locals => {:condition => tip.condition, :day => tip.weekday}
  end

  # moves tip to a different place
  def move
    tip = Tip.find(params[:occurrence_id])
    return unless authorize_guide tip.calendar_id

#    tip.condition = Condition.find(params[:condition_id])
#    tip.weekday = Weekday.find(params[:weekday_id])
    tip.condition_id = params[:condition_id]
    tip.weekday_id = params[:weekday_id]
    tip.save

    render :text => 'dummy response'
  end

  # switches two tips in one calendar
  def switch
    tip = Tip.find(params[:occurrence_id])
    return unless authorize_guide tip.calendar_id

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
    tip = Tip.find(params[:occurrence_id])
    render :partial => 'tips/show', :locals => {:tip => tip}
  end

  def edit
    tip = Tip.find(params[:occurrence_id])
    return unless authorize_guide tip.calendar_id
    render :partial => 'tips/edit', :locals => {:tip => tip}
  end

  def tile
    tip = Tip.find(params[:occurrence_id])
    @full_access = @current_user && (tip.calendar.user.id == @current_user.id);
    render :partial => 'tips/show_tile', :locals => {:tip => tip}
  end

end
