# http://cpanel.brazilwide.com.br
# gongon6442

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
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

Weekday.create(:name => "Monday")
Weekday.create(:name => "Tuesday")
Weekday.create(:name => "Wednesday")
Weekday.create(:name => "Thursday")
Weekday.create(:name => "Friday")
Weekday.create(:name => "Saturday")
Weekday.create(:name => "Sunday")