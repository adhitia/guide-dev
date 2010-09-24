class SetDefaultCompleted < ActiveRecord::Migration
  def self.up
    Calendar.all.each do |guide|
      guide.update_completed_percentage
      guide.save
    end
  end

  def self.down
  end
end
