class Rate < ApplicationRecord
  
  #relations
  belongs_to :exchange_table

  def published_at
    exchange_table.published_at
  end

end
