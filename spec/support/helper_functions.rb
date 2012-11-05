def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  find('input.submitButton').click
end

def valid_information
  fill_in "Name", with: "Example User"
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirmation", with: "foobar"
end

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  find('input.submitButton').click
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def valid_update_information(user)
  fill_in "Name",             with: new_name
  fill_in "Email",            with: new_email
  fill_in "Password",         with: user.password
  fill_in "Confirm Password", with: user.password
end

def edit_profile(user)
  visit edit_user_path(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  find('input.submitButton').click
end

