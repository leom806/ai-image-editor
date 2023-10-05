# frozen_string_literal: true

module OpenAI
  module Services
    #
    # Provides generation of an image from text
    #
    class Generate
      include ::ServiceObject

      VALID_SIZES = %w[256x256 512x512 1024x1024].freeze

      attr_reader :prompt, :size

      def initialize(prompt:, size: '256x256')
        @prompt = prompt
        @size = size
      end

      def call
        raise ArgumentError, 'prompt is required' if prompt.blank?
        raise ArgumentError, 'size is required' if size.blank?
        raise ArgumentError, 'size is invalid' unless valid_size?

        client
          .images
          .generate(parameters: parameters)
          .dig('data', 0, 'url')
      end

      def valid_size?
        size.in?(VALID_SIZES)
      end

      def client
        @client ||= OpenAI::Client.new
      end

      def parameters
        {
          prompt: prompt,
          size: size,
        }
      end
    end
  end
end
