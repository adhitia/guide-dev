require 'open-uri'

class Tip < ActiveRecord::Base
  attr_accessor :image_url

  has_one :address
  belongs_to :calendar
  belongs_to :condition
  belongs_to :weekday
  belongs_to :author, :class_name => 'User' 


  # include Paperclip
  has_attached_file :image, :styles => { :medium => "200x200>", :thumb => "100x100#" , :small => "100x100>",
                                          :square => "200x200#"},
                    # override 'original' style by    , :original => "400x400>"

                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "/:class/:attachment/:id/:style.:extension",
                    :default_style => :medium,
                    :default_url => "#{WEB_ROOT}/images/tip_missing.gif"
  before_validation :download_remote_image, :if => :image_url_provided?
  validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'

  accepts_nested_attributes_for :address, :allow_destroy => true

  validates_presence_of :author_id, :condition_id, :weekday_id, :calendar_id
  validates_length_of :name, :in => 1..25,  # allow no name, denoting no tip
                      :too_long => "{{count}} characters max",
                      :too_short => "required field"
  validates_length_of :url, :phone, :maximum => 255,
                      :too_long => "no more than {{count}} characters expected", :allow_nil => true
  validates_length_of :description, :maximum => 300,
                      :too_long => "no more than {{count}} characters expected"



  def image_exists?
    !self.image_remote_url.blank?
  end

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
