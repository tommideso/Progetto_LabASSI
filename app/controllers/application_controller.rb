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

end
