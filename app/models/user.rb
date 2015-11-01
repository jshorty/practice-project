class User < ActiveRecord::Base
  validates :email, uniqueness: true
  validates :password, length: { minimum: 8, allow_nil: true }
  validates :session_token, uniqueness: true

  after_initialize :ensure_session_token

  def password
    @password
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by_email(email)
    user.try(:is_password, password)
  end

  def ensure_session_token
    self.session_token ||= User.generate_token
  end

  def reset_session_token
    self.update!(session_token: User.generate_token)
    self.session_token
  end


  private


  def self.generate_token
    SecureRandom::urlsafe_base64
  end
end
