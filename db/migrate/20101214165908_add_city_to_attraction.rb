class AddCityToAttraction < ActiveRecord::Migration
  def self.up
    add_column :attractions, :city_id, :integer
    Tip.all.each do |tip|
      if !tip.attraction.nil?
        tip.attraction.city_id = tip.calendar.location_id
        tip.attraction.save!
      end
    end
  end

  def self.down
    remove_column :attractions, :city_id
  end
end
