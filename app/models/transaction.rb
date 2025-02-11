class Transaction < ApplicationRecord
  belongs_to :user
  
  validates :tx_hash, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  
  after_create :update_user_totals
  
  private
  
  def update_user_totals
    user.increment!(:total_transactions)
    user.increment!(:total_btc_received, amount)
  end
end