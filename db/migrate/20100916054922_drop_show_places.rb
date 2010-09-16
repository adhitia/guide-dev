class DropShowPlaces < ActiveRecord::Migration
  def self.up
    add_column :tips, :weekday_id, :integer

    ShowPlace.all.each do |sp|
      tip = sp.tip
      tip.condition_id = sp.condition_id
      tip.calendar_id = sp.calendar_id
      tip.weekday_id = sp.weekday_id
      tip.save
    end

#    drop_table :show_places
  end

  def self.down
  end
end
