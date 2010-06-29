class CreateShowPlaces < ActiveRecord::Migration
  def self.up
    create_table :show_places do |t|
      t.integer :condition_id
      t.integer :weekday_id
      t.integer :calendar_id
      t.integer :tip_id

      t.timestamps
    end
  end

  def self.down
    drop_table :show_places
  end
end
