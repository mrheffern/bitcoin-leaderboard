# app/services/bitcoin_api_service.rb
require 'net/http'
require 'uri'
require 'json'

class BitcoinApiService
  BASE_URL = 'https://mempool.space/api'

  def self.check_address(address)
    puts "Checking address: #{address}"
    uri = URI("#{BASE_URL}/address/#{address}/txs")  # Get actual transactions
    response = Net::HTTP.get_response(uri)
    
    unless response.is_a?(Net::HTTPSuccess)
      puts "API Error: #{response.code} - #{response.body}"
      return []
    end
    
    # Get transaction history
    transactions = JSON.parse(response.body)
    
    # Also get address info for validation
    address_uri = URI("#{BASE_URL}/address/#{address}")
    address_response = Net::HTTP.get_response(address_uri)
    address_info = JSON.parse(address_response.body)
    
    puts "Address info: #{address_info.inspect}"
    puts "Found #{transactions.length} transactions"
    
    transactions
  rescue StandardError => e
    puts "Error checking address: #{e.message}"
    puts e.backtrace.join("\n")
    []
  end
end