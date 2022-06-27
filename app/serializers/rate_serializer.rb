class RateSerializer < ActiveModel::Serializer
  attributes :currency, :code, :mid, :published_at
end
