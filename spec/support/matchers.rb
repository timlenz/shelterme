RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_header do |content|
  match do |page|
    page.should have_selector('h1', text: content)
  end
end

RSpec::Matchers.define :have_title do |content|
  match do |page|
    page.should have_selector('title', text: content)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-success', text: message)
  end
end

RSpec::Matchers.define :have_side_nav do |content|
  match do |page|
    page.should have_selector('h4', text: content)
  end
end