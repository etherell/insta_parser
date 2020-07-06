Rails.application.routes.draw do
  root 'users#index'
  post 'parse', to: 'users#parse'
  delete 'destroy', to: 'users#destroy'
end
