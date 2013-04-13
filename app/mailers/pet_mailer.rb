class PetMailer < ActionMailer::Base
  default from: "info@shelterme.com"
  
  def absent_pet(pet, user)
    @pet = pet
    @user = user
    mail to: 'admin@shelterme.com', subject: "Absent pet notice"
  end
end
