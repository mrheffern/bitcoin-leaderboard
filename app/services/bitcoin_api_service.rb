# app/services/bitcoin_api_service.rb
require 'net/http'
require 'json'

class BitcoinApiService
  BASE_URL = 'https://mempool.space/api'

  def self.check_address(address)
    uri = URI("#{BASE_URL}/address/#{address}/txs")
    response = Net::HTTP.get_response(uri)
    
    return [] unless response.is_a?(Net::HTTPSuccess)
    
    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error "Bitcoin API error: #{e.message}"
    []
  end
end