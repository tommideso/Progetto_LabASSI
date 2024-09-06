class PagesController < ApplicationController

  # Questo metodo è chiamato quando si accede alla root del sito
  # Se l'utente è loggato e ha ruolo admin, viene reindirizzato alla pagina admin 
  # Altrimenti viene reindirizzato alla pagina dei menu
  def index
    if user_signed_in? && current_user.ruolo == "admin"
      redirect_to admin_path
    else
      redirect_to menus_path
    end
  end
end
