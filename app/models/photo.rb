require 'open-uri'

# TODO delete data from amazon on destroy

class Photo < ActiveRecord::Base
  attr_accessor :image_url

  belongs_to :imageable, :polymorphic => true, :autosave => true

  include Paperclip

  has_attached_file :image, :styles => {:medium => "200x200>", :thumb => "100x100#", :small => "100x100>",
                                        :square => "200x200#"},
                    # override 'original' style by    , :original => "400x400>"
                    :storage        => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path           => "/:class/:attachment/:id/:style.:extension",
                    :default_style  => :medium,
                    :default_url    => "#{WEB_ROOT}/images/tip_missing.gif"


  after_post_process :save_image_dimensions

  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => /image/, :message => 'Image file expected.'
#  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png'], :message => 'Image file expected.'
  validates_attachment_size :image, :less_than => 1.megabytes

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
