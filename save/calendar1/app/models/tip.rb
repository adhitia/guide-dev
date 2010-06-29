require 'open-uri'

class Tip < ActiveRecord::Base
  attr_accessor :image_url

#  belongs_to :condition
#  belongs_to :calendar
#  has_and_belongs_to_many :weekdays
  has_many :show_places

  has_one :address
  has_many :show_places

#  include Paperclip
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  before_validation :download_remote_image, :if => :image_url_provided?
  validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'

  accepts_nested_attributes_for :calendar, :condition
  validates_presence_of :condition
  validates_presence_of :name

private
  # to make paperclip load urls
  def image_url_provided?
    !self.image_url.blank?
  end
  def download_remote_image
    self.image = do_download_remote_image
    self.image_remote_url = image_url
  end
  def do_download_remote_image
    io = open(image_url)
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end
