# frozen_string_literal: true

Rails.application.routes.draw do
  resources :images do
    collection do
      post :upload
    end

    member do
      post :upscale
    end
  end
end
