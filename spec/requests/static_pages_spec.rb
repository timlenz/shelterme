require 'spec_helper'

describe "Static pages" do

  subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_header(heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)     { 'Shelter Me' }
    let(:page_title)  { '' }

    it { should_not have_title('| Home') }
    it { should have_selector('div#heroCarousel') }
    it { should have_selector('h2', text:"Featured Pets")}
    it { should have_selector('h2', text:"Featured Shelter")}
    it { should have_selector('div.sidebar-element') }
    
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)     { 'Help' }
    let(:page_title)  { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)     { 'About' }
    let(:page_title)  { 'About' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)     { 'Contact' }
    let(:page_title)  { 'Contact' }

    it_should_behave_like "all static pages"
  end
  
  describe "FAQ page" do
    before { visit faq_path }
    let(:heading)     { 'Frequently Asked Questions' }
    let(:page_title)  { 'FAQ' }

    it_should_behave_like "all static pages"
  end
  
  describe "Terms page" do
    before { visit terms_path }
    let(:heading)     { 'Terms of Use' }
    let(:page_title)  { 'Terms of Use' }

    it_should_behave_like "all static pages"
  end
  
  describe "Privacy page" do
    before { visit privacy_path }
    let(:heading)     { 'Privacy Policy' }
    let(:page_title)  { 'Privacy Policy' }

    it_should_behave_like "all static pages"
  end
  
  it "should have the correct links on the layout" do
    visit root_path
    click_link "About"
    page.should have_title(full_title('About Us'))
    click_link "Help"
    page.should have_title(full_title('Help'))
    click_link "Contact"
    page.should have_title(full_title('Contact'))
    click_link "logo"
    page.should have_title(full_title(''))
  end
end