module Api
  module V1
    class ExchangeRatesController < ApplicationController

      def index

        currency_filter         = params[:currency_code]
        format_filter           = params[:format].downcase
        date_filter             = params[:selected_data]
        start_date_filter       = params[:start]
        end_date_filter         = params[:end]
        errors                  = []

        begin

          exchange_rates        = Rate.joins(:exchange_table)
          exchange_rates        = if currency_filter.present? && date_filter.present?
                                    exchange_rates.where("rates.code =? AND exchange_tables.published_at =?", currency_filter, date_filter)
                                  elsif currency_filter.present? && start_date_filter.present? && end_date_filter.present?
                                    exchange_rates.where("rates.code =? AND exchange_tables.published_at >=? AND exchange_tables.published_at <=?", currency_filter, start_date_filter, end_date_filter)
                                  elsif start_date_filter.present? && end_date_filter.present?
                                    exchange_rates.where("exchange_tables.published_at >=? AND exchange_tables.published_at <=?", start_date_filter, end_date_filter)
                                  elsif currency_filter.present?
                                    exchange_rates.where("rates.code =?", currency_filter)
                                  elsif date_filter.present?
                                    exchange_rates.where("exchange_tables.published_at =?", date_filter)
                                  else
                                    exchange_rates
                                  end

        rescue StandardError => e
          errors.push("Ooops! Something went wrong. Please contact tech support.")
        end

        if errors.blank?

          if format_filter == "xml"

            render xml: exchange_rates.as_json(only: [:currency, :code, :mid, :published_at])

          elsif format_filter == "csv"
            send_data render_csv(exchange_rates), type: 'text/plain',
                                          filename: 'exchange_rates.csv',
                                          disposition: 'attachment'
          else
            render json: exchange_rates, adapter: :json, meta: { average: average_currency_value(exchange_rates) }
          end
        else
          render json: {message: errors.join(',')}, status: :unprocessable_entity
        end
      end

      private

        def render_csv(records)

          attributes = %w{currency code mid published_at}
          header     = %w{Avarage}

          csv_string = CSV.generate(headers: true) do |csv|
                        csv << header
                        csv << [average_currency_value(records)]
                        csv << attributes.map{ |attr| attr.titleize }
                        records.each do |exchange_rate|
                          csv << attributes.map{ |attr| exchange_rate.send(attr) }
                        end
                      end
          csv_string
        end

        def average_currency_value(records)
          records.average(:mid)&.round(4)
        end
    end
  end
end
