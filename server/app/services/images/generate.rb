# frozen_string_literal: true

module Images
  #
  # Responsible for using AI to generate an image given a prompt
  #
  # @param [String] prompt
  # @param [Symbol] provider the provider to use for generating the image
  # @param [String] size the size of the image to generate
  #
  # Available providers:
  #   :openai
  #
  # Available sizes:
  #   256x256
  #   512x512
  #   1024x1024
  #
  # @return [String] url of the generated image
  #
  class Generate
    include ServiceObject

    attr_reader :prompt, :size, :provider

    def initialize(prompt:, provider: :openai, size: '256x256')
      @prompt = prompt
      @provider = provider
      @size = size
    end

    def call
      case provider
      when :openai
        ::OpenAI::Services::Generate.call(prompt: prompt, size: size)
      else
        raise ArgumentError, "Unknown provider: #{provider}"
      end
    end
  end
end
