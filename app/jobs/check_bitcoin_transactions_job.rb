# app/jobs/check_bitcoin_transactions_job.rb
class CheckBitcoinTransactionsJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each do |user|
      next unless user.btc_public_key.present?
      
      transactions = BitcoinApiService.check_address(user.btc_public_key)
      
      transactions.each do |tx|
        # Skip if we've already recorded this transaction
        next if Transaction.exists?(tx_hash: tx['txid'])
        
        # Calculate the amount received by this address
        amount = calculate_received_amount(tx, user.btc_public_key)
        
        Transaction.create!(
          user: user,
          tx_hash: tx['txid'],
          amount: amount,
          status: tx['status']['confirmed'] ? 'confirmed' : 'pending'
        )
      end
    end
  end

  private

  def calculate_received_amount(tx, address)
    # Sum up all outputs that went to this address
    tx['vout']
      .select { |vout| vout['scriptpubkey_address'] == address }
      .sum { |vout| vout['value'].to_f / 100_000_000 } # Convert sats to BTC
  end
end