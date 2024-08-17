Rails.application.routes.draw do
  # # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # le rotte devise per la registrazione vengono gestite dal controller 'registrations_controller.rb'
  # ho inoltre creato un controller per la conferma 
  devise_for :users, controllers: { registrations: "registrations", confirmations: "users/confirmations" }
  # le rotte per il completamento (che dipende dal ruolo scelto) vengono gestite dal controller 'complete_registrations_controller.rb'
  resource :complete_registration, only: [:new, :create]

  root "menus#index"
  resources :menus # definiamo le rotte crud per il controller menus_controller

  # per la gestione (temporanea delle email)
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
end
