class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show upscale update destroy ]

  def index
    @images = Image.all

    render json: @images.sorted
  end

  def show
    render json: @image
  end

  def create
    @image = Image.new(image_params)

    response = client.images.generate(
      parameters: {
        prompt: @image.prompt,
        size: "256x256"
      }
    )

    @image.url = response.dig("data", 0, "url")

    if @image.save
      render json: @image, status: :created, location: @image
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  def upload
    @image = Image.new(image_params)
    @image.url = params[:image][:base64_url]

    if @image.save
      render json: @image, status: :created, location: @image
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  def upscale
    path = File.join(Rails.root, "tmp", "upscale_#{@image.id}.png")
    mask_path = File.join(Rails.root, "public", "upscale_mask.png")

    if File.exist?(path)
      # Already being processed
      return head :no_content
    end

    File.binwrite(path, HTTParty.get(@image.url))

    response = HTTParty.post(
      "https://api.stability.ai/v1/generation/esrgan-v1-x2plus/image-to-image/upscale",
      multipart: true,
      headers: {
        'Authorization' => "Bearer #{ENV['STABILITY_API_KEY']}",
        'Accept' => 'application/json',
      },
      body: {
        image: File.open(path),
      }
    )

    base64_url = "data:image/png;base64,#{response["artifacts"][0]["base64"]}"

    File.delete(path)

    @upscale_image = Image.new(
      prompt: @image.prompt,
      url: base64_url,
      type: :upscale,
    )

    if @upscale_image.save
      render json: @upscale_image
    else
      render json: @upscale_image.errors, status: :unprocessable_entity
    end
  end

  def update
    if @image.update(image_params)
      render json: @image
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @image.destroy
  end

  private
    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:prompt)
    end

    def client
      @client ||= OpenAI::Client.new
    end
end
