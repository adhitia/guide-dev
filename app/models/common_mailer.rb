class CommonMailer < ActionMailer::Base
  
  def contact_us(name, email, message)
#    @user = user
#    @url  = "http://example.com/login"
#    mail({:from => "robomouse@gmail.com", :to => "nikita.rybak@gmail.com", :subject => "User contacted us"})
#    @from = "guiderer.test@gmail.com"
    @from = email
#    @to = "nikita.rybak@gmail.com"
    @recipients = "nikita.rybak@gmail.com"
    @subject = "User contact"
    @sent_on = Time.now
    @message = message;
    @name = name
  end
end
