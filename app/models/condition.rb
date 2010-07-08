class Condition < ActiveRecord::Base
  def next
    Condition.find(id + 1)
  end

  def prev
    Condition.find(id - 1)
  end

  def first?
    id == 1
  end

  def last?
    # TODO replace number with actual value 
    id == 9
  end
end
