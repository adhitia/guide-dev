#require "../app/helpers/application_helper.rb"
#include ApplicationHelper
# why fucking error?

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

def create_with_id(id, obj)
  obj.id = id
  obj.save
end


GuideType.delete_all
create_with_id 1, GuideType.new(:name => 'Simple')
create_with_id 2, GuideType.new(:name => 'Full')

Condition.delete_all
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
create_with_id 12, Condition.new(:guide_type_id => 1, :group => nil,         :name => "Day", :weather => "sunny", :full_name => "Sunny Day")
create_with_id 13, Condition.new(:guide_type_id => 1, :group => nil,         :name => "Day", :weather => "lousy", :full_name => "Lousy Day")
create_with_id 14, Condition.new(:guide_type_id => 1, :group => nil,         :name => "Dinner", :full_name => "Dinner")
create_with_id 15, Condition.new(:guide_type_id => 1, :group => nil,         :name => "Night", :full_name => "Night")

Weekday.delete_all
create_with_id 1, Weekday.new(:name => "Monday")
create_with_id 2, Weekday.new(:name => "Tuesday")
create_with_id 3, Weekday.new(:name => "Wednesday")
create_with_id 4, Weekday.new(:name => "Thursday")
create_with_id 5, Weekday.new(:name => "Friday")
create_with_id 6, Weekday.new(:name => "Saturday")
create_with_id 7, Weekday.new(:name => "Sunday")


create_with_id 1, GuideLayout.new(:name => 'tiny', :path => 'tiny', :public => true)
create_with_id 2, GuideLayout.new(:name => 'accordion', :path => 'accordion', :public => true)
create_with_id 3, GuideLayout.new(:name => 'other2', :path => 'other2')
create_with_id 4, GuideLayout.new(:name => 'other3', :path => 'other3')
create_with_id 5, GuideLayout.new(:name => 'other4', :path => 'other4')
create_with_id 6, GuideLayout.new(:name => 'other5', :path => 'other5')
create_with_id 7, GuideLayout.new(:name => 'other6', :path => 'other6')
create_with_id 8, GuideLayout.new(:name => 'other7', :path => 'other7')
