require "tzinfo"

def local(time)
  TZInfo::Timezone.get("Poland").local_to_utc(Time.parse(time))
end

every 1.minute do
  rake 'daily_sync:collect_and_store_exchange_rates'
end

