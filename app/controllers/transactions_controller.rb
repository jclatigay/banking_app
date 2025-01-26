class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def new
    @transaction = @account.transactions.build
    @transaction_type = params[:type]
  end

  def create
    @transaction = @account.transactions.build(transaction_params)

    if @transaction.save
      redirect_to account_path(@account), notice: "Transaction was successful."
    else
      @transaction_type = @transaction.transaction_type
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @transactions = current_user.accounts.map(&:transactions).flatten.sort_by(&:created_at).reverse

    @transactions = case params[:filter]
    when "deposits"
      @transactions.select { |t| t.transaction_type == "deposit" }
    when "withdrawals"
      @transactions.select { |t| t.transaction_type == "withdrawal" }
    when "transfers"
      @transactions.select { |t| t.transaction_type == "transfer" }
    else
      @transactions
    end
  end

  private

  def set_account
    @account = current_user.accounts.find_by(id: params[:account_id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :transaction_type, :description, :destination_account_id)
  end
end
