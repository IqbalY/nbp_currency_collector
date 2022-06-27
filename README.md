##### Important Note:

- The NBP Exchange Rates collector will start fetch/store the records after 1 day of its deployment date.

- It will only contains the records from its deployment date.

- You can fetch the records of current day by run the below command at console.

  ```bash
  ExchangeRatesCollector.new.process
  ```
##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [3.0.1]
- Rails [7.0.3]

##### 1. Create database.yml file

Copy the sample database.yml file and edit the database configuration as required.

```bash
cp config/database.yml.sample config/database.yml
```

##### 2. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:setup
```

##### 3. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```


##### 4. Postman Collection

You can find the collection file at root path with name: "nbp_exchange_rates_Apis.postman_collection.json" and import it into Postman to test the apis.

#### 5 Exchange Rates Collector Service

- A rake task(daily_sync:collect_and_store_exchange_rates) runs every day at "8:am" poland time zone to fetch and store the latest exchange rates records from provided NBP apis.

#### 6 APIs

- The below endpoints can use to fetch exchange rates records in different formates by using currency, specific date , start date, end date filters.

- {{BASE_URL}}/api/v1/exchange_rates
- {{BASE_URL}}/api/v1/exchange_rates?format=JSON
- {{BASE_URL}}/api/v1/exchange_rates?format=XML
- {{BASE_URL}}/api/v1/exchange_rates?format=CSV
- {{BASE_URL}}/api/v1/exchange_rates?selected_data=YYYY-MM-DD
- {{BASE_URL}}/api/v1/exchange_rates?currency_code=THB
- {{BASE_URL}}/api/v1/exchange_rates?end=YYYY-MM-DD&start=YYYY-MM-DD&format=JSON
- {{BASE_URL}}/api/v1/exchange_rates?end=YYYY-MM-DD&start=YYYY-MM-DD&format=XML
- {{BASE_URL}}/api/v1/exchange_rates?currency_code=THB&end=YYYY-MM-DD&start=YYYY-MM-DD
