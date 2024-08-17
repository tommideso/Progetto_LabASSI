class RegistrationsController < Devise::RegistrationsController
    # prima di ogni azione del controller, devise prende i parametri 
    before_action :configure_permitted_parameters, if: :devise_controller?
    # grazie a set_nested_attributes impostiamo gli attributi nestati per le azioni di edit ed update
    before_action :set_nested_attributes, only: [:edit, :update]

    def configure_permitted_parameters
        # consentiamo di prendere l'attributo 'personalizzato' chiave durante la registrazione
        devise_parameter_sanitizer.permit(:sign_up, keys: [:ruolo])
        # consentiamo di prendere anche gli altri attributi di client e chef durante la registrazone
        devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :cognome])
        # questi parametri devono poter essere aggiornati 
        devise_parameter_sanitizer.permit(:account_update, keys: [:nome, :cognome, 
                                          chef_attributes: [:indirizzo, :telefono, :raggio, :descrizione, :id], 
                                          client_attributes: [:indirizzo, :telefono, :allergeni, :id]])
    end

    # sovrascrivo il metodo create, chiamando comunque super, per impostare inizializzato a true
    # e passare poi al completamento (con il relativo controller)
    # def create
    #     super do |utente| 
    #         if utente.persisted?
    #             utente.update_column(:inizializzato, true)
    #             sign_in(utente)
    #             redirect_to new_complete_registration_path
    #             return
    #         end
    #     end
    # end
    # HO SPOSTATO QUESTA LOGICA NEL CONTROLLER DELLA CONFERMA DELL'EMAIL!

    private

    def set_nested_attributes
      if current_user.ruolo == "chef"
        @chef = current_user.chef || current_user.build_chef
      elsif current_user.ruolo == "client"
        @client = current_user.client || current_user.build_client
      end
    end
end