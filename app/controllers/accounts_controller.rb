class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [ :show ]

  def index
    @accounts = current_user.accounts
  end

  def show
    @account = Account.find(params[:id])
    @transactions = @account.transactions.order(created_at: :desc)

    case params[:filter]
    when "deposits"
      @transactions = @transactions.where(transaction_type: "deposit")
    when "withdrawals"
      @transactions = @transactions.where(transaction_type: "withdrawal")
    when "transfers"
      @transactions = @transactions.where(transaction_type: "transfer")
    end
  end

  def new
    @account = current_user.accounts.build
  end

  def create
    @account = current_user.accounts.build(account_params)

    if @account.save
      redirect_to accounts_path, notice: "Account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:account_type)
  end
end
