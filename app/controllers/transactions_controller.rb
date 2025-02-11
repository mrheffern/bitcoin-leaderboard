class TransactionsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @transactions = Transaction.order(created_at: :desc).limit(10)
  end

  def show
    @transaction = Transaction.find(params[:id])
  end
end