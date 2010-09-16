class Calendar < ActiveRecord::Base
  has_many :tips
  belongs_to :user
  belongs_to :location
  accepts_nested_attributes_for :tips
  accepts_nested_attributes_for :location

  validates_presence_of :location_id
  validates_length_of :name_location, :name_target, :in => 2..20,
                      :too_long => "no more than {{count}} characters expected",
                      :too_short => "at least {{count}} characters expected"

  def rating_num
    if votes_num == 0
      0
    else
      Float(votes_sum) / votes_num
    end
  end

  def rating_str
    if votes_num == 0
      "not rated"
    else
      "#{rating_num()}, #{votes_num} votes"
    end
  end

  def errors_as_hash
    result = {}
    result[:calendar_name_location] = errors.on(:name_location) if !errors.on(:name_location).blank?
    result[:calendar_name_target] = errors.on(:name_target) if !errors.on(:name_target).blank?
    result[:location_name] = errors.on(:location_id) if !errors.on(:location_id).blank?
    result
  end
end