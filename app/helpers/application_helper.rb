# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def times(number)
    number.to_s + ' time' + (number == 1 ? '' : 's');
  end

  def shorten(text, size = 70)
    if text.length > size
      text[0, size] + '...'
    else
      text
    end
  end

  def vertical_text(text)
    result = ''
    text.upcase.split("").each do |c|
      result += c + '<br/>'
    end
    result
  end

  def empty?(s)
    return s == nil || s.strip.empty?;
  end
end
