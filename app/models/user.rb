# use annotate-model gem to generate this info

# == Schema Information
# Schema version: <timestamp>
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor :password #provides getter and setter methods
  
  #tells Rails which attributes of the model are accessible, i.e., 
  #which attributes can be modified by outside users 
  attr_accessible :name, :email, :password, :password_confirmation
  
  #delete a users microposts when it is deleted
  has_many :microposts, :dependent => :destroy
  
  #need to explicitly tell Rails the foreign key as default is user_id
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  
  #default would be to treat "followeds" as plural of followed, use :source
  #parameter to override this as "following" better.
  #i.e. source of the following array is the set of followed ids. 
  has_many :following, :through => :relationships, :source => :followed
  
  #have to include class name otherwise rails looks for ReverseRelationships class
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  #could omit source in this case 
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  
  # Automatically create the virtual attribute 'password_confirmation'.
  # (virtual as only encypted password written to database)
  validates_confirmation_of :password
  
  # Password validations.
  validates_presence_of :password
  validates_length_of   :password, :within => 6..40

  #capital letter as this is a Ruby constant
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates_presence_of :name, :email
  validates_length_of   :name, :maximum => 50
  validates_format_of   :email, :with => EmailRegex
  #nb hitting submit twice can cause 2 identical records to be present
  #in db, so need to create database index on email column as well
  validates_uniqueness_of :email, :case_sensitive => false

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end 
  
  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}--#{Time.now.utc}")
    #store the remember token in the database. can't use save method as no virtual
    #password present when remember_me! called
    save_without_validation
  end 
  
  #class method
  def self.authenticate(email,submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
    #end of method automatically returns nil
  end
  
  
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  # ! indicates exception raised on failure
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  
  def feed
    Micropost.from_users_followed_by(self)
  end
     
  
  #register a callback called encypt_password
  before_save :encrypt_password

  private
  
    #perform encryption
    def encrypt_password
      unless password.nil? #will be nill when called before save_without_validation
        #must use self when assigning to an attribute, as otherwise would be defining a local variable
        #could do self.password but self not needed when accessing variable here
        self.salt = make_salt
        self.encrypted_password = encrypt(password)
      end
    end

    def encrypt(string)
      secure_hash("#{salt}#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end


end
