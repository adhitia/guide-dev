class CreateAdvertisements < ActiveRecord::Migration
  def self.up
    create_table :advertisements do |t|
      t.integer :condition_id
      t.integer :weekday_id
      t.integer :calendar_id
      t.integer :user_id
      t.integer :views_total
      t.integer :views_paid

      t.timestamps
    end
  end

  def self.down
    drop_table :advertisements
  end
end
