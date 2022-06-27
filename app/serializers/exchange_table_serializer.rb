class ExchangeTableSerializer < ActiveModel::Serializer
  attributes :published_at

  has_many :rates
end
