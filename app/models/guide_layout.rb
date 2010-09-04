class GuideLayout < ActiveRecord::Base
  validates_uniqueness_of :name, :path
end
