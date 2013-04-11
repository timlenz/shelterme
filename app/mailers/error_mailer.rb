class ErrorMailer < ActionMailer::Base
  default from: "info@shelterme.com"
  
  def error_notification(exception)
    @exception = exception
    mail to: 'admin@shelterme.com', subject: "500 Error Encountered"
  end
end
