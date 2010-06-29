class Calendar < ActiveRecord::Base
  has_many :show_places
  belongs_to :user
  belongs_to :location
  accepts_nested_attributes_for :show_places
  accepts_nested_attributes_for :location

  validates_presence_of :name

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
end