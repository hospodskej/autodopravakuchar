Rails.application.routes.draw do
  root "pages#cenik"

  get "cenik", to: "pages#cenik", as: :cenik
  get "kontakty", to: "pages#kontakty", as: :kontakty
  get "sluzby", to: "pages#sluzby", as: :sluzby
  get "technika-a-vybaveni", to: "pages#technika", as: :technika

  get "up" => "rails/health#show", as: :rails_health_check
end
