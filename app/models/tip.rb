require 'open-uri'

class Tip < ActiveRecord::Base
  MAX_NAME_LENGTH = 35

  attr_accessor :image_url

#  has_one :address
  belongs_to :attraction
  belongs_to :calendar
  belongs_to :condition
#  belongs_to :weekday
  belongs_to :author, :class_name => 'User'

  has_many :book_tips, :dependent => :destroy


  # include Paperclip
  has_attached_file :image, :styles => {:medium => "200x200>", :thumb => "100x100#", :small => "100x100>",
                                        :square => "200x200#"},
                    # override 'original' style by    , :original => "400x400>"

                    :storage        => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path           => "/:class/:attachment/:id/:style.:extension",
                    :default_style  => :medium,
                    :default_url    => "#{WEB_ROOT}/images/tip_missing.gif"

  after_post_process :save_image_dimensions

  before_validation :download_remote_image, :if => :image_url_provided?
  validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'
#  after_validation :save_image_dimensions

#  accepts_nested_attributes_for :attraction #, :allow_destroy => true

  validates_presence_of :author_id, :condition_id, :calendar_id
  validates_length_of :name, :in => 1..MAX_NAME_LENGTH, # allow no name, denoting no tip
                      :too_long  => "{{count}} characters max",
                      :too_short => "required field"
  validates_length_of :url, :phone, :maximum => 255,
                      :too_long              => "no more than {{count}} characters expected", :allow_nil => true
#  validates_length_of :description, :maximum => 300,
#                      :too_long => "no more than {{count}} characters expected"

  after_destroy {|tip|
    if !tip.attraction.nil?
      tip.attraction.popularity -= 1
      tip.attraction.save!
    end
  }


  def image_exists?
    self.image.file?
  end

  def save_image_dimensions
    geo = Paperclip::Geometry.from_file(image.queued_for_write[:original])
    self.image_width = geo.width
    self.image_height = geo.height
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

    def io.original_filename;
      base_uri.path.split('/').last;
    end

    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end
