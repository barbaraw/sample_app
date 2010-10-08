require 'spec_helper'

describe "Layout links" do
  it "should have a Home page at '/'" do
    get '/'
    response.should render_template('pages/home')
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should render_template('pages/contact')
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should render_template('pages/about')
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should render_template('pages/help')
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should render_template('users/new')
  end
  
  #tests the links on the layout actually go to the correct page
  #need webrat for this to work
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    response.should render_template('pages/about')
    click_link "Help"
    response.should render_template('pages/help')
    click_link "Contact"
    response.should render_template('pages/contact')
    click_link "Home"
    response.should render_template('pages/home')
=begin
    click_link "Sign up now!"
    response.should render_template('pages/signup')
=end
  end
end
