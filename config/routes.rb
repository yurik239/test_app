require 'resque/server'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :suppliers
  resources :items
  resources :imports
  
  mount Resque::Server.new, at: "/resque"
  
  
end
