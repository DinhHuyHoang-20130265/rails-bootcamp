class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :display_name, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3 }
  validates :password, presence: true,
            format: {
              with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}\z/,
              message: "must be at least 8 characters, include uppercase, lowercase, and numbers, and contain only letters and digits"
            },
            if: -> { password.present? }
  has_many :tweets, dependent: :destroy

  # --- Make email optional for Devise ---
  def email_required?
    false
  end

  # For Devise/ActiveModel change tracking (Rails 5+)
  def will_save_change_to_email?
    false
  end
end
