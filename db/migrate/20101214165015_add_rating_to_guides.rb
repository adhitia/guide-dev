class AddRatingToGuides < ActiveRecord::Migration
  def self.up
    add_column :calendars, :rating, :float
    Calendar.all.each do |guide|
      guide.update_rating
      guide.save!
    end
  end

  def self.down
  end
end
