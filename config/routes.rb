Rails.application.routes.draw do
  root "welcome#index"
  get "/map", to: "welcome#map"  # or a dedicated controller
end
