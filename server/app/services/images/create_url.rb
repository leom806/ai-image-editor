# frozen_string_literal: true

module Images
  #
  # Generates a Base64 url from a given image url
  # Currently works only with png images
  # It's used to avoid losing the image when the external service is down
  # Using base64 is not the best solution, but it's to void costs with S3 for now
  #
  class CreateUrl
    include ServiceObject

    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def call
      base_64_url
    end

    def base_64_url
      "data:image/png;base64,#{Base64.strict_encode64(HTTParty.get(url))}"
    end
  end
end
