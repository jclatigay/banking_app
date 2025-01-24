class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :account_type, presence: true, inclusion: { in: [ "checking", "savings" ] }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :account_number, presence: true, uniqueness: true

  before_validation :generate_account_number, on: :create

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
end
