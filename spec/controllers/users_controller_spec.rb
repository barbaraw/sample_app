require 'spec_helper'

describe UsersController do
  #tell RSpec to integrate the views inside the controller tests. 
  #By default RSpec just tests actions inside a controller test; 
  #if we want it also to render the views, we have to tell it explicitly via integrate_views:
  integrate_views

  describe "GET 'new'" do
    
	it "should be successful" do
      get 'new'
      response.should be_success
    end
	
	it "should have the right title" do
      get 'new'
	  #use regex. check title includes "Sign up"
      response.should have_tag("title", /Sign up/)
	end

  end
  
  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      # Arrange for User.find(params[:id]) to find the right user.
      #stub is a facility provided by rspec to avoid hits on db
	  #any call to User.find with given id will return @user
	  User.stub!(:find, @user.id).and_return(@user)
    end

    it "should be successful" do
	  #nb can do get 'show' or get :show
	  #could do => @user.id but rails automatically converts
	  #user object to its id
      get :show, :id => @user
      response.should be_success
    end
  end

end
