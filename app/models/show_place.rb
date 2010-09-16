class ShowPlace < ActiveRecord::Base
  belongs_to :calendar
  belongs_to :condition
  belongs_to :weekday
  belongs_to :tip

  validates_presence_of :condition_id, :weekday_id, :calendar_id, :tip_id
end


