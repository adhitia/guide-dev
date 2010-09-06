#require "../app/helpers/application_helper.rb"
#include ApplicationHelper
# why fucking error?

# http://cpanel.brazilwide.com.br
# gongon6442

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


Condition.delete_all
create_with_id 1, Condition.new(:id => 1, :group => "day", :name => "Morning", :weather => "sunny")
create_with_id 2, Condition.new(:id => 2, :group => "day", :name => "Morning", :weather => "lousy")
create_with_id 3, Condition.new(:id => 3, :group => "day", :name => "Lunch")
create_with_id 4, Condition.new(:id => 4, :group => "day", :name => "Afternoon", :weather => "sunny")
create_with_id 5, Condition.new(:id => 5, :group => "day", :name => "Afternoon", :weather => "lousy")
create_with_id 6, Condition.new(:id => 6, :group => "dinner", :name => "Ritzy")
create_with_id 7, Condition.new(:id => 7, :group => "dinner", :name => "Traditional")
create_with_id 8, Condition.new(:id => 8, :group => "dinner", :name => "Cheap")
create_with_id 9, Condition.new(:id => 9, :group => "nightlife", :name => "Clubbing")
create_with_id 10, Condition.new(:id => 10, :group => "nightlife", :name => "Live Music")
create_with_id 11, Condition.new(:id => 11, :group => "nightlife", :name => "Chilling")

Weekday.delete_all
create_with_id 1, Weekday.new(:id => 1, :name => "Monday")
create_with_id 2, Weekday.new(:id => 2, :name => "Tuesday")
create_with_id 3, Weekday.new(:id => 3, :name => "Wednesday")
create_with_id 4, Weekday.new(:id => 4, :name => "Thursday")
create_with_id 5, Weekday.new(:id => 5, :name => "Friday")
create_with_id 6, Weekday.new(:id => 6, :name => "Saturday")
create_with_id 7, Weekday.new(:id => 7, :name => "Sunday")


create_with_id 1, GuideLayout.new(:id => 1, :name => 'tiny', :path => 'tiny', :public => true)
create_with_id 2, GuideLayout.new(:id => 2, :name => 'other1', :path => 'other1', :public => true)
create_with_id 3, GuideLayout.new(:id => 3, :name => 'other2', :path => 'other2', :public => true)
create_with_id 4, GuideLayout.new(:id => 4, :name => 'other3', :path => 'other3', :public => true)
create_with_id 5, GuideLayout.new(:id => 5, :name => 'other4', :path => 'other4', :public => true)
create_with_id 6, GuideLayout.new(:id => 6, :name => 'other5', :path => 'other5', :public => true)
create_with_id 7, GuideLayout.new(:id => 7, :name => 'other6', :path => 'other6', :public => true)
create_with_id 8, GuideLayout.new(:id => 8, :name => 'other7', :path => 'other7', :public => true)
