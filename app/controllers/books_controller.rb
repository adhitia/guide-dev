require 'RMagick'

class BooksController < ApplicationController
  def update
#    book = authorize_book params[:id]
    book = verify_book params[:id]

#    book.image_data = params[:image_data]
    if params[:tips]
      params[:tips].each_pair do |id, tip_data|
        book_tip = BookTip.find id, :lock => true
        book_tip.update_attributes! tip_data
      end
    end

    book.save

    render :text => book.id
  end

  def print_order
    @book = authorize_book params[:id]
    @guide = @book.calendar

    render :template => 'calendars/print_order'
  end

  def print
#    book = authorize_book
    book = verify_book params[:id]
    guide = book.calendar

    pdf = Prawn::Document.new(:page_size => [Book::BOOK_WIDTH, Book::BOOK_HEIGHT], :margin => 0)
    pdf.font "Times-Roman"

    # print title page
    pdf.text guide.name, :size => 26

    book.book_tips.each do |book_tip|
      tip = book_tip.tip

      # draw text
      pdf.start_new_page
      top = Book::BOOK_HEIGHT - 60
      margin = 60
      pdf.draw_text(tip.condition.full_name, :at => [margin, top], :size => 26)

      top -= 50
      pdf.draw_text(book_tip.name.blank? ? tip.name : book_tip.name, :at => [margin, top], :size => 50)

      top -= 50
      address = book_tip.address.blank? ? tip.address : book_tip.address
      phone = book_tip.phone.blank? ? tip.phone : book_tip.phone
      pdf.draw_text(address + '   ' + phone, :at => [margin, top], :size => 26)

      top -= 35
      pdf.draw_text(book_tip.url.blank? ? tip.url : book_tip.url, :at => [margin, top], :size => 26)

#      top -= 35
#      pdf.draw_text(, :at => [margin, top], :size => 26)

      top -= 40
      pdf.text_box(book_tip.description.blank? ? tip.description : book_tip.description, :size => 26,
                   :at => [pdf.bounds.left + margin, top], :width => Book::BOOK_WIDTH - 2*margin,
                   :overflow => :shrink_to_fit, :min_font_size => 18)


      # draw image
      pdf.start_new_page
      if tip.image.file?
        begin
          puts "printing tip #{tip.id} : #{tip.image.url}"

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
          rm.crop! book_tip.image_offset_x, book_tip.image_offset_y, width, height
          rm.write(image)


          pdf.image image, :fit => [Book::BOOK_WIDTH, Book::BOOK_HEIGHT]
        rescue Prawn::Errors::UnsupportedImageType
          pdf.text 'Not supported image type: only JPG and PNG are supported so far.'
        end
      else
        pdf.text 'No image.'
      end
    end

#    pdf.text("some other text")
#    pdf.render_file('prawn.pdf')

    send_data pdf.render, :filename => 'guide-book.pdf', :type => 'application/pdf', :disposition => 'inline'
  end

end