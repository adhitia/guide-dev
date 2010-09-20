class Condition < ActiveRecord::Base
  belongs_to :guide_type

  def next
    Condition.find(id + 1)
  end

  def prev
    Condition.find(id - 1)
  end

#  def first?
#    id == 1
#  end

#  def last?
#    id == 11
#  end
end
