class AddSizeToImages < ActiveRecord::Migration
  def self.up
    add_column :tips, :image_width, :integer
    add_column :tips, :image_height, :integer

    Tip.all.each do |tip|
      if tip.image.file?
#        puts "tip #{tip.id}"
#        puts "url #{tip.image.url(:original)}"

        begin
          geo = Paperclip::Geometry.from_file(tip.image.to_file(:original))
          tip.image_width = geo.width
          tip.image_height = geo.height
          tip.save
        rescue AWS::S3::NoSuchKey
          puts "image is absent for tip #{tip.id} in guide #{tip.calendar.id}"
#          puts "#{$!.class} : #{$!}"
        end
      end
    end
  end

  def self.down
  end
end
