module CalendarsHelper
  def present_day_of_week(dow)
    ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][dow]
  end

  def present_day(day)
    if day == 0 then
      "Today"
    elsif day == 1 then
      "Tomorrow"
    else
      (Date.today + day).strftime '%m/%d'
    end
  end

#  def validateGuide()
#    puts "!!!!!!!!!!!!!!"
#  end
end
