require 'spec_helper'

describe "Static pages" do

  subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)     { 'Shelter Me' }
    let(:page_title)  { '' }

    it { should_not have_title('| Home') }
    it { should have_selector('div#heroCarousel') }
    it { should have_selector('div.pet-tile') }
    it { should have_selector('div.featured-shelter')}
    it { should have_selector('div.sidebar-element') }
    
  end

  describe "Help page" do
    before { visit help_path }
    let(:sideNav)     { 'Help' }
    let(:page_title)  { 'Help' }

    it_should_behave_like "all static pages"
    it { should have_side_nav(sideNav) }
  end

  describe "About page" do
    before { visit about_path }
    let(:sideNav)     { 'About' }
    let(:page_title)  { 'About' }

    it_should_behave_like "all static pages"
    it { should have_side_nav(sideNav) }
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:sideNav)     { 'Contact' }
    let(:page_title)  { 'Contact' }

    it_should_behave_like "all static pages"
    it { should have_side_nav(sideNav) }
  end
  
  describe "FAQ page" do
    before { visit faq_path }
    let(:sideNav)     { 'FAQ' }
    let(:page_title)  { 'FAQ' }

    it_should_behave_like "all static pages"
    it { should have_side_nav(sideNav) }
  end
  
  describe "Terms page" do
    before { visit terms_path }
    let(:sideNav)     { 'Terms of Use' }
    let(:page_title)  { 'Terms of Use' }

    it_should_behave_like "all static pages"
    it { should have_side_nav(sideNav) }
  end
  
  describe "Privacy page" do
    before { visit privacy_path }
    let(:sideNav)     { 'Privacy Policy' }
    let(:page_title)  { 'Privacy Policy' }

    it_should_behave_like "all static pages"
    it { should have_side_nav(sideNav) }
  end
  
  describe "Match Me page" do
    before { visit matchme_path }
    let(:heading)     { 'Describe Yourself' }
    let(:page_title)  { 'Match Me' } 
  end
  
  describe "Find Pet page" do
    before { visit findpet_path }
    let(:page_title)  { 'Find Pet' }
  end
  
  it "should have the correct links on the layout" do
    visit root_path
    click_link "About"
    page.should have_title(full_title('About Us'))
    click_link "Help"
    page.should have_title(full_title('Help'))
    click_link "Contact"
    page.should have_title(full_title('Contact'))
    click_link "FAQ"
    page.should have_title(full_title('FAQ'))
    click_link "Terms"
    page.should have_title(full_title('Terms of Use'))
    click_link "Privacy"
    page.should have_title(full_title('Privacy Policy'))
  end
end