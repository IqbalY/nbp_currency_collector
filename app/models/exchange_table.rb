class ExchangeTable < ApplicationRecord

  #enums
  enum tab_num: [:a, :b], _prefix: :type

  #relations
  has_many :rates, dependent: :destroy

end
