class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :destination_account, class_name: "Account", optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[deposit withdrawal transfer] }
  validates :description, presence: true
  validate :sufficient_funds, if: -> { [ "withdrawal", "transfer" ].include?(transaction_type) }

  TRANSACTION_TYPES = {
    deposit: "deposit",
    withdrawal: "withdrawal",
    transfer: "transfer"
  }.freeze

  after_create :update_account_balances
  after_create :create_mirror_transfer, if: :transfer?

  private

  def update_account_balances
    case transaction_type
    when "deposit"
      account.update!(balance: account.balance + amount)
    when "withdrawal"
      account.update!(balance: account.balance - amount)
    when "transfer"
      account.transaction do
        account.update!(balance: account.balance - amount)
      end
    end
  end

  def sufficient_funds
    return unless amount
    if account.balance < amount
      errors.add(:base, "Insufficient funds for #{transaction_type}")
    end
  end

  def transfer?
    transaction_type == "transfer" && destination_account.present?
  end

  def create_mirror_transfer
    destination_account.transactions.create!(
      amount: amount,
      transaction_type: "deposit",
      description: "Transfer from #{account.account_type.titleize} (#{account.account_number})",
      status: status,
      mirror_transfer: true
    )
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, "Failed to create corresponding deposit: #{e.message}")
    raise ActiveRecord::Rollback
  end

  def mirror_transfer?
    mirror_transfer == true
  end
end
