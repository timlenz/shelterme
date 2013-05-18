class ShelterMailer < ActionMailer::Base
  default from: "info@shelterme.com"
  
  def submit_shelter(shelter, user)
    @shelter = shelter
    @user = user
    mail to: 'admin@shelterme.com', subject: "New user shelter submission"
    mail reply_to: @user.email
  end
end
