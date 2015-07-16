class Session < ActiveRecord::Base
  validate :ensure_session_token
  validates :user_id, :session_token, :name, presence: true
  validates :session_token, uniqueness: true
  belongs_to :user

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end
  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save
  end
end
