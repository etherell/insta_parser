Rails.application.routes.draw do
  root 'users#index'
  post 'parse', to: 'users#parse'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
