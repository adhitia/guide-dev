class FixConditions < ActiveRecord::Migration
  def self.up
    drop_table :conditions
    create_table "conditions", :force => true do |t|
      t.string   "name"
      t.string   "weather"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "group"
    end


    Condition.create(:id => 1, :group => "day", :name => "Morning", :weather => "sunny")
    Condition.create(:id => 2, :group => "day", :name => "Morning", :weather => "lousy")
    Condition.create(:id => 3, :group => "day", :name => "Lunch")
    Condition.create(:id => 4, :group => "day", :name => "Afternoon", :weather => "sunny")
    Condition.create(:id => 5, :group => "day", :name => "Afternoon", :weather => "lousy")
    Condition.create(:id => 6, :group => "dinner", :name => "Ritzy")
    Condition.create(:id => 7, :group => "dinner", :name => "Traditional")
    Condition.create(:id => 8, :group => "dinner", :name => "Cheap")
    Condition.create(:id => 9, :group => "nightlife", :name => "Clubbing")
    Condition.create(:id => 10, :group => "nightlife", :name => "Live Music")
    Condition.create(:id => 11, :group => "nightlife", :name => "Chilling")
  end

  def self.down
  end
end
