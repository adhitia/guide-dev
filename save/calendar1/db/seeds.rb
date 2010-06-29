# http://cpanel.brazilwide.com.br
# gongon6442

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
Condition.create(:name => "Sunny")
Condition.create(:name => "Cloudy")
Condition.create(:name => "Rainy")
Condition.create(:name => "Dinner - Ritzy")
Condition.create(:name => "Dinner - Casual")
Condition.create(:name => "Dinner - Cheap")
Condition.create(:name => "Clubbing")
Condition.create(:name => "Live music")
Condition.create(:name => "Chilling")

Weekday.create(:name => "Monday")
Weekday.create(:name => "Tuesday")
Weekday.create(:name => "Wednesday")
Weekday.create(:name => "Thursday")
Weekday.create(:name => "Friday")
Weekday.create(:name => "Saturday")
Weekday.create(:name => "Sunday")