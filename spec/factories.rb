#A factory to simulate User model objects.

# By using the symbol ':user', we ensure Factory Girl will guess we want to use User model.
# so @user will simulate an instance of User
Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

# now we can create a User factory in the tests like this:
# @user = Factory(:user)
