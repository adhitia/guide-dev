class CalendarRatingDefault < ActiveRecord::Migration
  def self.up
    change_column :calendars, :rating, :float, :default => 0
    Calendar.all.each do |guide|
      guide.update_completed_percentage
      guide.save!
    end
  end

  def self.down
  end
end
