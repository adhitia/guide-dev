class Calendar < ActiveRecord::Base
#  has_many :tips
  has_many :show_places
  belongs_to :user
  belongs_to :location
#  accepts_nested_attributes_for :tips
  accepts_nested_attributes_for :show_places
  accepts_nested_attributes_for :location

  validates_presence_of :name
end