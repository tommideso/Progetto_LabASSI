class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pagy::Backend

  before_action :set_query

  def set_query
    @q=Menu.ransack(params[:q])
  end

  # Metodo per cambiare il testo del bottone in base alla presenza del preferito
  def favorite_class
    @favorite_exists ? "fill-red-500 stroke-red-500" : " stroke-red-500"
  end
  def favorite_text
    @favorite_exists ? "Rimuovi dai preferiti" : "Aggiungi ai preferiti"
  end

  helper_method :favorite_class
  helper_method :favorite_text

  # metodo per mostrare la pagina d'errore 404
  def render_404
    respond_to do |format|
      format.html { render file: Rails.public_path.join("404.html"), status: :not_found, layout: false }
      format.json { render json: { error: "Not Found" }, status: :not_found }
    end
  end

  private

  # Metodi per controllare il ruolo dell'utente
  def check_if_chef
    unless current_user.ruolo == "chef"
        flash[:alert] = "Il ruolo non consente tale azione"
        redirect_to root_path
    end
  end
  def check_if_client
    unless current_user.ruolo == "client"
      flash[:alert] = "Il ruolo non consente tale azione"
      redirect_to root_path
    end
  end

  def check_if_admin
    unless current_user.ruolo == "admin"
      flash[:alert] = "Il ruolo non consente tale azione"
      redirect_to root_path
    end
  end
end
