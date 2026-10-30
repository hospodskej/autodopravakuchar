Rails.application.routes.draw do
  root "pages#home"

  get "sluzby", to: "pages#sluzby", as: :sluzby
  get "technika-a-vybaveni", to: "pages#technika", as: :technika
  get "cenik", to: "pages#cenik", as: :cenik
  get "kontakty", to: "pages#kontakty", as: :kontakty

  get "up" => "rails/health#show", as: :rails_health_check
end
