# frozen_string_literal: true

module Images
  #
  # Uses an AI service to upscale an existing image
  #
  # @param [Image] image the image to upscale
  # @param [Symbol] provider the provider to use for upscaling
  # @providers [:stability]
  #
  # @return [Image] the upscaled image
  #
  class Upscale
    include ServiceObject

    attr_reader :image, :provider

    def initialize(image:, provider: :stability)
      @image = image
      @provider = provider
    end

    def call
      return image if image.upscale?
      return already_upscaling if already_upscaling?

      @tempfile.close
      @tempfile.unlink

      Image.new(
        prompt: image.prompt,
        url: base64_url,
        type: :upscale
      )
    end

    def already_upscaling
      Image.new.errors.add(:base, 'Already upscaling')
    end

    def already_upscaling?
      File.exist?(tempfile_path)
    end

    def base64_url
      "data:image/png;base64,#{base64_response}"
    end

    def base64_response
      case provider
      when :stability
        ::Stability::API.upscale(image: tempfile)
      else
        raise ArgumentError, "Unknown provider: #{provider}"
      end
    end

    def tempfile
      @tempfile ||= begin
        File.binwrite(tempfile_path, image_binary)
        File.open(tempfile_path)
      end
    end

    def tempfile_path
      @tempfile_path ||= Rails.root.join('tmp', "upscale_#{image.id}.png").to_s
    end

    def image_binary
      File.new Base64.decode64(@image.url.split(',', 2).last)
    end
  end
end
