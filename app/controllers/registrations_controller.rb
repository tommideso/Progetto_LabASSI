class RegistrationsController < Devise::RegistrationsController
    # prima di ogni azione del controller, devise prende i parametri 
    before_action :get_params, if: :devise_controller?

    def get_params
        # consentiamo di prendere l'attributo 'personalizzato' chiave durante la registrazione
        devise_parameter_sanitizer.permit(:sign_up, keys: [:ruolo])
        # consentiamo di prendere anche gli altri attributi di client e chef durante la registrazone
        devise_parameter_sanitizer.permit(:sign_up, keys: [:telefono, :indirizzo, :raggio, :descrizione, :allergeni])
        # questi parametri devono poter essere aggiornati 
        devise_parameter_sanitizer.permit(:account_update, keys: [:telefono, :indirizzo, :raggio, :descrizione, :allergeni])
    end

    # sovrascriviamo il metodo create per creare un'istanza di chef o cliente a seconda della scelta dell'utente
    def create
        super do |utente|
            if utente.persisted? # se l'utente effettivamente esiste
                if utente.role == "chef"
                    Chef.create!(user: utente)
                elsif utente.role == "client"
                    Client.create!(user: utente)
                end
            end
        end
    end
end
