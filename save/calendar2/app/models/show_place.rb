class ShowPlace < ActiveRecord::Base
  belongs_to :calendar
  belongs_to :condition
  belongs_to :weekday
  belongs_to :tip
end


