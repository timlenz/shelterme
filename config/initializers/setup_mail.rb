ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "timlenz@gmail.com",
  :password             => "yasUda1@umr",
  :authentication       => "plain",
  :enable_starttls_auto => true
}