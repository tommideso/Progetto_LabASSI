class RegistrationsController < Devise::RegistrationsController
    # prima di ogni azione del controller, devise prende i parametri 
    before_action :get_params, if: :devise_controller?

    def get_params
        # consentiamo di prendere l'attributo 'personalizzato' chiave durante la registrazione
        devise_parameter_sanitizer.permit(:sign_up, keys: [:ruolo])
        # consentiamo di prendere anche gli altri attributi di client e chef durante la registrazone
        devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :cognome])
        # questi parametri devono poter essere aggiornati 
        devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :cognome])
    end

    # sovrascriviamo il metodo create per creare un'istanza di chef o cliente a seconda della scelta dell'utente
    def create
        super do |utente|
            if utente.persisted? && utente.ruolo.present?
                sign_in(utente)
                redirect_to new_complete_registration_path
                return
            end
        end
    end
end
