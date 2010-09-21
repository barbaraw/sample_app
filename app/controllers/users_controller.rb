class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]
  before_filter :new_user, :only => [:new, :create]
  
  def index
    @title = "All users"
    #@users = User.all
    #use will_paginate gem to limit number of users displayed
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user #user show page
    else
      #clear password
      @user.password = ""
      @user.password_confirmation = ""
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    #@user set in correct_user
    @title = "Edit user"
  end
  
  def update
    #@user set in correct_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end  
  
  def destroy
    user = User.find(params[:id])
    if user.admin?
      flash[:notice] = "Cannot delete administrator"
    else
      user.destroy
      flash[:success] = "User destroyed." 
    end
    redirect_to users_path
  end
  
  private
    #must be signed in to edit and update user info
    def authenticate
      deny_access unless signed_in?
    end  
    
    #Signed-in users have no reason to access the new and create actions in the Users controller
    def new_user
      if signed_in?
        flash[:notice] = "Already signed in"
        redirect_to(root_path)
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end 
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end

