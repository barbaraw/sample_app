class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  
  validates_presence_of :content, :user_id
  validates_length_of   :content, :maximum => 140
    
  #order posts from newest to oldest
  default_scope :order => 'created_at DESC'
  
  # Return microposts from the users being followed by the given user.
  # nb code for home page creates a paginated feed so only 30 microposts 
  # will be pulled from database
  named_scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private

    # Return an SQL condition for users followed by the given user.
    # We include the user's own id as well.
    def self.followed_by(user)
	  #get ids of users that user follows
	  
      #line below commented out as use subselect instead 
	  #followed_ids = user.following.map(&:id) #same as .map { |user| user.id }
	  
	  #This code contains an SQL subselect which arranges for all the set logic to 
	  #be pushed into the database, which is more efficient
	  followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
	  
	  #conditions for getting posts for feed
	  #could have done :conditions => ["... OR user_id = ?", user] but whwn need same 
	  #variable inserted in more than one place using a hash is more convenient
      { :conditions => ["user_id IN (#{followed_ids}) OR user_id = :user_id",
                        { :user_id => user }] }
    end
  
end
