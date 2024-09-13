class PagesController < ApplicationController
  # Questo metodo è chiamato quando si accede alla root del sito
  # Se l'utente è loggato e ha ruolo admin, viene reindirizzato alla pagina admin
  # Altrimenti viene reindirizzato alla pagina dei menu
  def index
    if user_signed_in? && current_user.admin?
      redirect_to profiles_path
    elsif user_signed_in? && current_user.chef?
      redirect_to profile_path(current_user)
    elsif user_signed_in? && !current_user.completed?
      redirect_to new_complete_registration_path
    else
      redirect_to menus_path
    end
  end
end
