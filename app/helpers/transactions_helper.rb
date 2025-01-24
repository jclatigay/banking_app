module TransactionsHelper
  def transaction_icon(transaction)
    case transaction.transaction_type
    when "deposit"
      "fa-arrow-down"
    when "withdrawal"
      "fa-arrow-up"
    when "transfer"
      "fa-exchange-alt"
    end
  end
end
