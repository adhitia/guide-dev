class CommonMailer < ActionMailer::Base
  
  def contact_us(name, email, message)
    @from = email
    @recipients = CONTACT_EMAILS_TO
    @subject = "User contact"
    @sent_on = Time.now
    @message = message;
    @name = name
  end
end
