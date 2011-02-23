# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def title(page_title)
    content_for(:title) { h page_title }
  end

  def page_width(w)
    content_for(:page_width) { h w }
  end

  def times(number)
    format_number(number, "time")
#    number.to_s + ' time' + (number == 1 ? '' : 's');
  end

  def format_number(number, entity)
    if entity =~ /y\z/
      multiple = entity[0, entity.length - 1] + 'ies'
    else
      multiple = entity + 's'
    end
    "#{number} #{number == 1 ? entity : multiple}"
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

#  def empty?(s)
#    return s == nil || s.strip.empty?;
#  end

  def escape(&block)
    text = capture(&block)
    text = text.gsub(/[&><"]/) { |special|
      ERB::Util::HTML_ESCAPE[special]
    }
    concat text
  end

  def guide_url(guide)
    "#{WEB_ROOT}/guides/#{guide.id}/#{for_url(guide.name)}"
  end

  def guide_link(guide)
    link_to h(guide.name), guide_url(guide)
#    link_to guide.name, show_guide_path(:id => guide)
#    , {:target => '_blank'}
  end

  def city_link(city)
    link_to "#{city.name}", "#{WEB_ROOT}/cities/#{city.id}/#{for_url(city.name)}"
#     (#{city.guides.length} guides)
  end

  def for_url(s)
    s.gsub(/\s/, "-").gsub(/["'\[\]:\/\\<>#%~^`|]/, "")
  end

#  def show_errors(name, &block)
#    if !@errors.nil? and @errors[name]
#      concat "<span class='fieldWithErrors'>"
#      concat capture(&block)
#      concat "</span>"
#    else
#      concat capture(&block)
#    end
#  end

  def has_errors(name)
    !@errors.nil? and !@errors[name].nil?
  end
end
