require 'sidekiq/web'

Rails.application.routes.draw do
  get 'images', to: 'images#index'
  get 'images/:id', to: 'images#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
end
