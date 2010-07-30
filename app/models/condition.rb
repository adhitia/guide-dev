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
    id == 11
  end

  def full_name
    if weather == nil
      if group == 'dinner'
        name.capitalize + ' ' + group.capitalize
      else
        name
      end
    else
      weather.capitalize + ' ' + name.capitalize
    end
  end
end
