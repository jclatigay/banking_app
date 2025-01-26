class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :dashboard ]

  def home
  end

  def index
  end

  def dashboard
    if current_user
      @recent_transactions = current_user.accounts.map(&:transactions).flatten.sort_by(&:created_at).reverse

      @recent_transactions = case params[:filter]
      when "deposits"
        @recent_transactions.select { |t| t.transaction_type == "deposit" }
      when "withdrawals"
        @recent_transactions.select { |t| t.transaction_type == "withdrawal" }
      when "transfers"
        @recent_transactions.select { |t| t.transaction_type == "transfer" }
      else
        @recent_transactions
      end.first(5)
    end
  end
end
