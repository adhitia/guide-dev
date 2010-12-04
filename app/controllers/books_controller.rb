require 'RMagick'

class BooksController < ApplicationController
  def update
    book = authorize_book params[:id]

    book.image_data = params[:image_data]
    book.save

    render :text => book.id
  end

  def print
#    book = authorize_book
    book = verify_book params[:id]
    guide = book.calendar

    pdf = Prawn::Document.new(:page_size => [600, 300], :margin => 0)

    # print title page
    pdf.text guide.name, :size => 26

    guide.tips.each do |tip|
      if book.image_data[tip.id.to_s].nil? && tip.image.file?
        next
      end

      pdf.start_new_page
      if tip.image.file?
        begin
          puts "printing tip #{tip.id} : #{tip.image.url}"
          crop_data = book.image_data[tip.id.to_s]

          image = tip.image.to_file(:original).path
          rm = Magick::ImageList.new(image)

          scroll_x = tip.image_height * Book::BOOK_PROPORTION < tip.image_width
          if scroll_x
            height = tip.image_height
            width = Book::BOOK_PROPORTION * tip.image_height
          else
            height = tip.image_width / Book::BOOK_PROPORTION
            width = tip.image_width
          end

          puts image
          puts "crop arguments ! #{[crop_data[:left], crop_data[:top], width, height].inspect}"
          rm.crop! crop_data[:left].to_i, crop_data[:top].to_i, width, height
          rm.write(image)


          pdf.image image, :fit => [600, 300]
        rescue Prawn::Errors::UnsupportedImageType
          pdf.text 'Not supported image type: only JPG and PNG are supported so far.'
        end
      else
        pdf.text 'No image.'
      end

      pdf.start_new_page
      pdf.draw_text(tip.condition.full_name, :at => [20, pdf.bounds.top - 20], :size => 16)
      pdf.draw_text(tip.name, :at => [40, Book::BOOK_HEIGHT - 60], :size => 24)

      pdf.text_box(tip.description, :size => 16, :at => [pdf.bounds.left + 40, pdf.bounds.top - 100],
                   :overflow => :shrink_to_fit, :min_font_size => 12)
    end

#    pdf.text("some other text")
#    pdf.render_file('prawn.pdf')

    send_data pdf.render, :filename => 'guide-book.pdf', :type => 'application/pdf', :disposition => 'inline'
  end

end