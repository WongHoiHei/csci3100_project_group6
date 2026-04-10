Rails.application.routes.draw do
  root 'pages#welcome'
  get "/map", to: "bookings#map"  # or a dedicated controller
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/signup', to: 'registrations#new'
  post '/signup', to: 'registrations#create'

  get '/password/edit', to: 'passwords#edit'
  patch '/password', to: 'passwords#update'

  get '/main', to: 'pages#main' 

  get '/venue-booking', to: 'bookings#map'
  get '/equipment-booking', to: 'bookings#equipment'

  get 'buildings/:slug', to: 'buildings#show', as: :building

  get '/booking/confirmation', to: 'bookings#confirmation'
  get '/booking/final', to: 'bookings#final', as: :booking_final

  get '/search', to: 'search#index'

  resources :dashboards, only: [:index]
  
  get '/bookings/new', to: 'bookings#new'
  post '/bookings', to: 'bookings#create'
  get '/bookings/:id', to: 'bookings#show' #show id booking
  get '/bookings', to: 'bookings#index' #show all bookings
  delete '/bookings/:id', to: 'bookings#destroy'
end
