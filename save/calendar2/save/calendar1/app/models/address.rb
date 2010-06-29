class Address < ActiveRecord::Base
  belongs_to :tip
  has_one :location
end
