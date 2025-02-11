class TransactionsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @transactions = Transaction.order(created_at: :desc).limit(10)
  end

  def new
    @transaction = current_user.transactions.build
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)
    @transaction.status = 'pending' # Initial status

    if @transaction.save
      redirect_to transactions_path, notice: 'Transaction recorded successfully!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:tx_hash, :amount)
  end
end