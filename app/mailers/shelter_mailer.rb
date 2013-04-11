class ShelterMailer < ActionMailer::Base
  default from: "info@shelterme.com"
  
  def submit_shelter(shelter, user)
    @shelter = shelter
    @user = user
    mail to: 'steven@shelterme.com', subject: "New user shelter submission"
  end
end
