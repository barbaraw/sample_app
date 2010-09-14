#We could just edit the migration file for the users table but that would require rolling back and then migrating back up. 
#The Rails Way is to use migrations every time we discover that our data model needs to change.
class AddEmailUniqenessIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :users, :email
  end
end
