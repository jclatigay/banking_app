class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :accounts, dependent: :destroy
  has_many :activity_logs

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true, uniqueness: true

  after_create :log_user_creation

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def log_user_creation
    activity_logs.create!(
      action: "user_created",
      description: "Account created",
      metadata: {
        email: email,
        created_at: created_at.strftime("%B %d, %Y at %I:%M %p")
      }
    )
  end
end
