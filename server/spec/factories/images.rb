# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    prompt { 'A cool image' }
    url { 'https://i.imgur.com/random.png' }
    type { 'regular' }
  end
end
