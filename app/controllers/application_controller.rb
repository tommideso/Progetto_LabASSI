class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pagy::Backend 

  before_action :set_query

  def set_query
    @q=Menu.ransack(params[:q])   
  end

  # Metodo per cambiare il testo del bottone in base alla presenza del preferito
  def favorite_text
    return @favorite_exists ? "Rimuovi dai preferiti" : "Aggiungi ai preferiti"
  end
  
  helper_method :favorite_text

  private

  # Metodi per controllare il ruolo dell'utente
  def check_if_chef
    unless current_user.ruolo == "chef"
        redirect_to root_path, alert: "Il ruolo non consente tale azione"
    end
  end
  def check_if_client
    unless current_user.ruolo == "client"
      redirect_to root_path, alert: "Il ruolo non consente tale azione"
    end
  end

  def check_if_admin
    unless current_user.ruolo == "admin"
      redirect_to root_path, alert: "Il ruolo non consente tale azione"
    end
  end

end
