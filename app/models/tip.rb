require 'open-uri'

class Tip < ActiveRecord::Base
  attr_accessor :image_url

  has_one :address
  has_many :show_places

  # include Paperclip
  has_attached_file :image, :styles => { :medium => "200x200>", :thumb => "100x100#" , :small => "100x100>",
                                          :square => "200x200#" , :original => "300x300>" }, # override 'original' style
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "/:class/:attachment/:id/:style.:extension",
#                    :bucket => 'guiderer',
                    :default_style => :medium,
                    :default_url => "/images/tip_missing.gif"
  before_validation :download_remote_image, :if => :image_url_provided?
  validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'

  accepts_nested_attributes_for :address

  validates_presence_of :author_id
  validates_length_of :name, :in => 1..25,
                      :too_long => "{{count}} characters max",
                      :too_short => "required field"
  validates_length_of :url, :phone, :maximum => 255,
                      :too_long => "no more than {{count}} characters expected", :allow_nil => true
  validates_length_of :description, :maximum => 300,
                      :too_long => "no more than {{count}} characters expected"



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
