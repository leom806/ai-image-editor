# frozen_string_literal: true

#
# Handles all the image related actions
#
class ImagesController < ApplicationController
  before_action :set_image, only: %i[show upscale update destroy]

  def index
    @images = Image.all

    render json: @images.sorted
  end

  def show
    render json: @image
  end

  def create
    @image = Image.new(image_params)

    @url = Images::Generate.call(prompt: @image.prompt)
    @image.url = Images::CreateUrl.call(url: @url)

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
    @upscale_image = Images::Upscale.call(image: @image)

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
end
