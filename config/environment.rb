# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ShelterMe::Application.initialize!

# Configure ActionMailer's delivery method
#config.action_mailer.delivery_method = :smtp