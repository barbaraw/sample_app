class Relationship < ActiveRecord::Base
  attr_accessible :followed_id
  
  #Rails can’t guess the foreign keys from the class name User; moreover, 
  #since there is neither a Followed nor a Follower model, we need to supply the class name as well.
  belongs_to :follower, :foreign_key => "follower_id", :class_name => "User"
  belongs_to :followed, :foreign_key => "followed_id", :class_name => "User"
end
