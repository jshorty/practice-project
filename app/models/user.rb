class User < ActiveRecord::Base
  validates :email, unique: true
  validates :password, length: { minimum: 8, allow_nil: true }

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
end
