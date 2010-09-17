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
  
  #class method
  def self.authenticate(email,submitted_password)
    user.find_by_email(email)
    return nill if user.nil?
    return user if user.has_password?(submitted_password)
    #end of method automatically returns nil
  end
     
  
  #register a callback called encypt_password
  before_save :encrypt_password

  private
  
    #perform encryption
    def encrypt_password
      #must use self when assigning to an attribut, as otherwise would be defining a local variable
      #could do self.password but self not needed when accessing variable here
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
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
