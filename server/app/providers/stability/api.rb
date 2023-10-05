# frozen_string_literal: true

module Stability
  #
  # Stability public API
  #
  module API
    module_function

    #
    # Provides upscaling for an image File object
    #
    # @param [File] image the image to upscale
    #
    # @return [String] a base64 string encoded image
    #
    def upscale(image:)
      Services::Upscale.call(image: image)
    end
  end
end
