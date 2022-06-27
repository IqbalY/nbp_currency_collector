class ExchangeTable < ApplicationRecord

  #enums
  enum tab_type: [:a, :b], _prefix: :type

  #relations
  has_many :rates, dependent: :destroy

end
