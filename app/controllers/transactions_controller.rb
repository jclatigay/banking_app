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

  private

  def set_account
    @account = current_user.accounts.find(params[:account_id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :transaction_type, :description, :destination_account_id)
  end
end
