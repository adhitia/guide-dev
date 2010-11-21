class CommonMailer < ActionMailer::Base
  
  def contact_us(name, email, message)
    @from = email
    @recipients = CONTACT_EMAILS_TO
    @subject = "User contact"
    @sent_on = Time.now
    @message = message;
    @name = name
  end

  def print_order(book, type)
    @book = book
    @guide = book.calendar
    @type = type

    @from = @guide.user.email
    @recipients = BOOK_ORDER_EMAILS_TO
    @subject = "new print order"
  end
end
