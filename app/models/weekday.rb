class Weekday < ActiveRecord::Base
  attr_protected

  def next
    Weekday.find((id % 7) + 1)
  end

  def prev
    Weekday.find(((id + 5) % 7) + 1)
  end

#  def first?
#    id == 1
#  end
#
#  def last?
#    id == 7
#  end

#  def full_name
#    name
#  end

end
