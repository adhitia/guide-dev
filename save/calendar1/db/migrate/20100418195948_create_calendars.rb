class CreateCalendars < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.string :name
      t.string :author
      t.string :location_id
      t.string  :location_name
      t.integer :view_count
      t.integer :click_count

      t.timestamps
    end
  end

  def self.down
    drop_table :calendars
  end
end
