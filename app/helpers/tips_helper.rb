module TipsHelper
  def interest(i)
    if @tip
      @tip.weekdays.include?(i)
    else
      false
    end
  end
end
