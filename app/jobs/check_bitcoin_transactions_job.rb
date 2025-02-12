class CheckBitcoinTransactionsJob
  def perform
    puts "Starting job at #{Time.current}"
    
    User.find_each do |user|
      puts "Checking user: #{user.email} with address: #{user.btc_public_key}"
      next unless user.btc_public_key.present?
      
      transactions = BitcoinApiService.check_address(user.btc_public_key)
      
      transactions.each do |tx|
        next if Transaction.exists?(tx_hash: tx['txid'])
        
        # Find outputs to our address
        amount = tx['vout']
          .select { |vout| vout['scriptpubkey_address'] == user.btc_public_key }
          .sum { |vout| vout['value'].to_f / 100_000_000 }

        # Skip if we didn't receive anything in this transaction
        next if amount <= 0

        puts "Recording transaction: #{tx['txid']}"
        puts "Amount: #{amount} BTC"
        puts "Status: #{tx['status']['confirmed'] ? 'confirmed' : 'pending'}"

        Transaction.create!(
          user: user,
          tx_hash: tx['txid'],
          amount: amount,
          status: tx['status']['confirmed'] ? 'confirmed' : 'pending'
        )
      end
    end

    puts "Job completed at #{Time.current}"
    Delayed::Job.enqueue(CheckBitcoinTransactionsJob.new, run_at: 1.minute.from_now)
  end
end