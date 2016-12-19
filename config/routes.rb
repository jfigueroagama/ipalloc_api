Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'devices/*address', to: 'devices#show', constraints: { address: /[0-9.]+/ }, defaults: { format: :json }
  
end
