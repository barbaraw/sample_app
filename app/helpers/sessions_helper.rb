module SessionsHelper
  
  def sign_in(user)
    #save the users remember token to the database
    user.remember_me!
    cookies[:remember_token] = {:value => user.remember_token, :expires => 20.years.from_now.utc}
    #current_user is now avaliable in both controllers and views
    #In the context of the Sessions helper, the self in self.current_user is the Sessions controller, 
    #since the module is being included into the Application controller, which is the base class for 
    #all the other controllers (including Sessions). 
    self.current_user = user 
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    #if @current_user already set return @current_user without calling user_from_remember_token
    @current_user ||= user_from_remember_token
  end
  
  def current_user?(user)
    user == current_user
  end

  def user_from_remember_token
    remember_token = cookies[:remember_token]
    User.find_by_remember_token(remember_token) unless remember_token.nil?
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def authenticate
    deny_access unless signed_in?
  end
    
  def deny_access
    store_location
    flash[:notice] = "Please sign in to access this page."
    redirect_to signin_path
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def clear_return_to
    session[:return_to] = nil
  end
  
end
