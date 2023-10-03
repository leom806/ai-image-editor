class Image < ApplicationRecord
  validates :prompt, presence: true
  validates :url,    presence: true, format: URI::regexp(%w[http https])

  scope :sorted, -> { order(id: :desc) }
end
