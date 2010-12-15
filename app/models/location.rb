class Location < ActiveRecord::Base
  has_one :weather_forecast
  has_many :guides, :class_name => "Calendar"

  validates_presence_of :code, :name

  def short_name
    if name.index(',')
      name[0..name.index(',') - 1]
    else
      name
    end
  end
end
