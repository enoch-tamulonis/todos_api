class User < ApplicationRecord
  has_many :tasks

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password

  def as_json
    {
      email: email,
    }.to_json
  end
end
