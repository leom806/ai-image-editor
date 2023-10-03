class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show update destroy ]

  def index
    @images = Image.all

    render json: @images.sorted
  end

  def show
    render json: @image
  end

  def create
    @client = OpenAI::Client.new
    @image = Image.new(image_params)

    response = @client.images.generate(
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
end
