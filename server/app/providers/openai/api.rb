# frozen_string_literal: true

module OpenAI
  #
  # OpenAI public API
  #
  module API
    module_function

    #
    # Provides image generation from text
    #
    # @param [String] prompt of the image to generate
    #
    # @return [String] url of the generated image
    #
    def generate(prompt:)
      Services::Generate.call(prompt: prompt)
    end
  end
end
