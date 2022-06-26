class ExchangeRatesCollector

  EXCHANGE_RATES_PRIMARY_SOURCE_URL   = "http://api.nbp.pl/api/exchangerates/tables/A".freeze
  EXCHANGE_RATES_SECONDARY_SOURCE_URL = "http://api.nbp.pl/api/exchangerates/tables/B".freeze
  INVALID_API_CODES                   = [400, 500, 404]

  def initialize ; end

  def process
    primary_source_data       = fetch_data_from_source(EXCHANGE_RATES_PRIMARY_SOURCE_URL)
    secondary_source_data     = fetch_data_from_source(EXCHANGE_RATES_SECONDARY_SOURCE_URL)
    collected_exchange_rates  = primary_source_data + secondary_source_data
    save_collected_exchange_rates(collected_exchange_rates)
  end


  private

  def fetch_data_from_source(source_url)
    response = HTTParty.get(source_url)
    response = [] if INVALID_API_CODES.include?(response.code) && response.message.kind_of?(String)
    response
  end

  def save_collected_exchange_rates(collected_exchange_rates)

    return if collected_exchange_rates.blank?

    collected_exchange_rates.each do |collected_exchange_rate|
      next if exchange_rate_already_present?(collected_exchange_rate)
      exchange_rate = ExchangeTable.new(
                                        tab_type: ExchangeTable.tab_nums[collected_exchange_rate["table"].downcase], 
                                        published_at: collected_exchange_rate["effectiveDate"]
                                      )
      
      if exchange_rate.save
        exchange_rate.rates.create(collected_exchange_rate["rates"])
      end
    end
  end

  def exchange_rate_already_present?(collected_exchange_rate)
    published_date  = collected_exchange_rate["effectiveDate"]
    tab_no          = collected_exchange_rate["table"].downcase
    exchange_rate   = ExchangeTable.find_by(published_at: published_date, tab_type: ExchangeTable.tab_nums[tab_no])
    exchange_rate.present?
  end
end