class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  has_many :activity_logs, as: :trackable

  validates :account_type, presence: true, inclusion: { in: [ "checking", "savings" ] }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :account_number, presence: true, uniqueness: true

  before_validation :generate_account_number, on: :create

  after_create :log_account_creation

  def other_accounts
    user.accounts.where.not(id: id)
  end

  private

  def generate_account_number
    loop do
      self.account_number = SecureRandom.hex(5).upcase
      break unless Account.exists?(account_number: account_number)
    end
  end

  def log_account_creation
    user.activity_logs.create!(
      trackable: self,
      action: "account_created",
      description: "#{account_type.titleize} account created",
      metadata: {
        account_type: account_type,
        account_number: account_number,
        created_at: created_at.strftime("%B %d, %Y at %I:%M %p")
      }
    )
  end
end
