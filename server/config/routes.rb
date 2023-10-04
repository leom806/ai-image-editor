Rails.application.routes.draw do
  resources :images do
    member do
      post :upscale
    end
  end
end
