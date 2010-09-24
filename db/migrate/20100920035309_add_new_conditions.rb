class AddNewConditions < ActiveRecord::Migration
  def self.create_with_id(id, obj)
    obj.id = id
    obj.save
  end

  def self.up

    create_table :guide_types, :force => true do |t|
      t.string :name
    end
    create_with_id 1, GuideType.new(:name => 'Simple')
    create_with_id 2, GuideType.new(:name => 'Full') 


    create_table "conditions", :force => true do |t|
      t.string   "name"
      t.string   "weather"
      t.string   "full_name"
      t.integer  "guide_type_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "group"
    end


    create_with_id 1,  Condition.new(:guide_type_id => 2, :group => "day",       :name => "Morning", :weather => "sunny", :full_name => "Sunny Morning")
    create_with_id 2,  Condition.new(:guide_type_id => 2, :group => "day",       :name => "Morning", :weather => "lousy", :full_name => "Lousy Morning")
    create_with_id 3,  Condition.new(:guide_type_id => 2, :group => "day",       :name => "Lunch", :full_name => "Lunch")
    create_with_id 4,  Condition.new(:guide_type_id => 2, :group => "day",       :name => "Afternoon", :weather => "sunny", :full_name => "Sunny Afternoon")
    create_with_id 5,  Condition.new(:guide_type_id => 2, :group => "day",       :name => "Afternoon", :weather => "lousy", :full_name => "Lousy Afternoon")
    create_with_id 6,  Condition.new(:guide_type_id => 2, :group => "dinner",    :name => "Ritzy", :full_name => "Ritzy Dinner")
    create_with_id 7,  Condition.new(:guide_type_id => 2, :group => "dinner",    :name => "Traditional", :full_name => "Traditional Dinner")
    create_with_id 8,  Condition.new(:guide_type_id => 2, :group => "dinner",    :name => "Cheap", :full_name => "Cheap Dinner")
    create_with_id 9,  Condition.new(:guide_type_id => 2, :group => "nightlife", :name => "Clubbing", :full_name => "Clubbing")
    create_with_id 10, Condition.new(:guide_type_id => 2, :group => "nightlife", :name => "Live Music", :full_name => "Live Music")
    create_with_id 11, Condition.new(:guide_type_id => 2, :group => "nightlife", :name => "Chilling", :full_name => "Chilling")
    create_with_id 12, Condition.new(:guide_type_id => 1, :group => "simple",    :name => "Day", :weather => "sunny", :full_name => "Sunny Day")
    create_with_id 13, Condition.new(:guide_type_id => 1, :group => "simple",    :name => "Day", :weather => "lousy", :full_name => "Lousy Day")
    create_with_id 14, Condition.new(:guide_type_id => 1, :group => "simple",    :name => "Dinner", :full_name => "Dinner")
    create_with_id 15, Condition.new(:guide_type_id => 1, :group => "simple",    :name => "Night", :full_name => "Night")


    add_column :calendars, :guide_type_id, :integer
    Calendar.update_all ["guide_type_id = ?", 2]
  end

  def self.down
  end
end
