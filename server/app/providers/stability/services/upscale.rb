# frozen_string_literal: true

module Stability
  module Services
    #
    # Provides upscaling for an image File object via the Stability API
    #
    class Upscale
      include ::ServiceObject

      URL = 'https://api.stability.ai/v1/generation/esrgan-v1-x2plus/image-to-image/upscale'

      attr_reader :image

      def initialize(image:)
        @image = image
      end

      def call
        HTTParty.post(
          URL,
          multipart: true,
          headers: headers,
          body: body
        )['artifacts'][0]['base64']
      end

      def headers
        {
          'Authorization' => "Bearer #{api_key}",
          'Accept' => 'application/json',
        }
      end

      def body
        {
          image: image,
        }
      end

      def api_key
        ENV.fetch('STABILITY_API_KEY', nil)
      end
    end
  end
end
