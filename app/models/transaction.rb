class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :destination_account, class_name: "Account", optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[deposit withdrawal transfer] }
  validates :description, presence: true

  TRANSACTION_TYPES = {
    deposit: "deposit",
    withdrawal: "withdrawal",
    transfer: "transfer"
  }.freeze

  after_create :update_account_balances
  after_create :create_mirror_transfer, if: :transfer?

  private

  def update_account_balances
    begin
      case transaction_type
      when "deposit"
        account.update!(balance: account.balance + amount)
      when "withdrawal"
        if account.balance >= amount
          account.update!(balance: account.balance - amount)
        else
          raise StandardError, "Insufficient funds for withdrawal"
        end
      when "transfer"
        if account.balance >= amount
          account.transaction do
            account.update!(balance: account.balance - amount)
            destination_account.update!(balance: destination_account.balance + amount)
          end
        else
          raise StandardError, "Insufficient funds for transfer"
        end
      end
    rescue StandardError => e
      errors.add(:base, e.message)
      raise ActiveRecord::Rollback
    end
  end

  def transfer?
    transaction_type == "transfer" && destination_account.present?
  end

  def create_mirror_transfer
    # Create the corresponding transaction record for the destination account
    destination_account.transactions.create!(
      amount: amount,
      transaction_type: "deposit",
      description: "Transfer from #{account.account_type.titleize} (#{account.account_number})",
      status: status
    )
  end
end
