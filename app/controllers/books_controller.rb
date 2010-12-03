class BooksController < ApplicationController
  def update
    book = authorize_book params[:id]
    book.save

    render :text => book.id
  end

  def print
    book = authorize_book
    guide = book.calendar

    pdf = Prawn::Document.new(:page_size => [600, 300], :margin => 0)

    # print title page
    pdf.text guide.name, :size => 26

    guide.tips.each do |tip|
      pdf.start_new_page
      if tip.image.file?
        p tip.image.url(:thumb)
        begin
          pdf.image open(tip.image.url), :fit => [600, 300]
        rescue Prawn::Errors::UnsupportedImageType
          pdf.text 'Not supported image type: only JPG and PNG are supported so far.'
        end
      else
        pdf.text 'No image.'
      end

      pdf.start_new_page
      pdf.draw_text(tip.condition.full_name, :at => [20, pdf.bounds.top - 20], :size => 16)
      pdf.draw_text(tip.name, :at => [40, Book.BOOK_HEIGHT - 60], :size => 24)

      pdf.text_box(tip.description, :size => 16, :at => [pdf.bounds.left + 40, pdf.bounds.top - 100],
                   :overflow => :shrink_to_fit, :min_font_size => 12)
    end

#    pdf.text("some other text")
#    pdf.render_file('prawn.pdf')

    send_data pdf.render, :filename => 'guide-book.pdf', :type => 'application/pdf', :disposition => 'inline'
  end

end