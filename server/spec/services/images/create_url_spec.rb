# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Images::CreateUrl, type: :service do
  describe '#call' do
    subject(:service) { described_class.call(url:) }

    let(:url) { 'https://i.imgur.com/random.png' }
    let(:image_base64) { 'aW1hZ2U=' }

    before do
      allow(HTTParty).to receive(:get).with(url).and_return('image')
    end

    it { expect(Base64.strict_encode64('image')).to eq(image_base64) }

    it 'returns the base64 url' do
      expect(service).to eq("data:image/png;base64,#{image_base64}")
    end
  end
end
