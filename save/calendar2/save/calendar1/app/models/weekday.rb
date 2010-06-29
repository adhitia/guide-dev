class Weekday < ActiveRecord::Base
#  has_and_belongs_to_many :tips

  def next
    Weekday.find((id % 7) + 1)
  end

  def prev
    Weekday.find(((id + 5) % 7) + 1)
  end
end
