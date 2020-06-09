Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do 
  	namespace :v1 do
  		resources :users
  		post '/users/sign_in' => 'users#sign_in'
  		delete '/users/sign_out' => 'users#destroy'
  		resources :tweets

  	end
  end
end