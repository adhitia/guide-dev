class Advertisement < ActiveRecord::Base
  belongs_to :condition
  belongs_to :weekday
  belongs_to :calendar
  belongs_to :user
end
