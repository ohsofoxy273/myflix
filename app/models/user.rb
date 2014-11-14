class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, 
						uniqueness: { case_sensitive: false }, 
						presence: true, 
						length: {maximum: 250},
						format: { with: VALID_EMAIL_REGEX }

	validates :name, 
						uniqueness: true, 
						presence: true, 
						length: {maximum: 50}

	validates :password, length: {minimum: 6}
end
