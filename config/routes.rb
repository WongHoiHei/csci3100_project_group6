Rails.application.routes.draw do
  root 'pages#welcome'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/signup', to: 'registrations#new'
  post '/signup', to: 'registrations#create'

  get '/password/edit', to: 'passwords#edit'
  patch '/password', to: 'passwords#update'

  get '/main', to: 'pages#main'

  get '/venue-booking', to: 'bookings#venue'
  get '/equipment-booking', to: 'bookings#equipment'

  get '/booking/confirmation', to: 'bookings#confirmation'
  get '/booking/final', to: 'bookings#final'

  get '/search', to: 'search#index'
end