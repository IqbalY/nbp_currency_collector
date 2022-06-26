namespace :daily_sync do
  desc "Collect and store exchange rates"
  task collect_and_store_exchange_rates: :environment do
    ExchangeRatesCollector.new.process
  end
end