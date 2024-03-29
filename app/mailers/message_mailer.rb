class MessageMailer < ActionMailer::Base
  default from: "info@shelterme.com"

  def send_message(message)
    @message = message
    mail to: 'admin@shelterme.com', subject: "Contact form message"
    mail reply_to: @message.email
  end
end
