Rails.application.routes.draw do
  get "favorites/update"
  # # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # le rotte devise per la registrazione vengono gestite dal controller 'registrations_controller.rb'
  # ho inoltre creato un controller per la conferma 
  devise_for :users, controllers: { registrations: "registrations", 
                                  confirmations: "users/confirmations", 
                                  omniauth_callbacks: "users/omniauth_callbacks", 
                                  sessions: "users/sessions" }
  # le rotte per il completamento (che dipende dal ruolo scelto) vengono gestite dal controller 'complete_registrations_controller.rb'
  resource :complete_registration, only: [:new, :create]
  # definiamo le rotte per il controller user (questo controller serve per gestire gli utenti lato chat)
  get 'users/show'
  get 'user/:id', to: 'users#show', as: 'user'
  # usiamo devise_scope per definire una rotta personalizzata: l'indirizzo GET /users porta ora al controller session di devise
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
  end
  # rotte per le stanze (cioè la chat); per ogni rotta dei messaggi definiamo le rotte nestate per i messaggi
  resources :rooms do
    resources :messages
  end

  # definiamo la root path
  root "menus#index"
  # resources :menus # definiamo le rotte crud per il controller menus_controller
  # Per la gestione delle immagini
  resources :menus do
    member do
      # remove_image_menu_path(image)
      delete :remove_image
      get :versions
      get 'versions/:version_id', to: 'menus#show_version', as: 'version'
    end
  end

  # rotte per le prenotazioni
  resources :reservations

  # per la gestione (temporanea delle email)
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  get 'search', to: 'search#index'

  # rotte per i preferiti
  resources :favorites, only: [:index]
end
