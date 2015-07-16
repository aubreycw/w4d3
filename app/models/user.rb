

class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true
  attr_reader :password

  has_many :cats
  has_many :cat_rental_requests
  has_many :sessions

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
      BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end
end
