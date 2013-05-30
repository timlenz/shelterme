class ErrorMailer < ActionMailer::Base
  default from: "info@shelterme.com"
  
  def error_notification(exception,user,page)
    @exception = exception
    @user = user
    @page = page
    mail to: 'admin@shelterme.com', subject: "Error Encountered"
  end
end
