class PagesController < ApplicationController
  # Questo metodo è chiamato quando si accede alla root del sito
  # Se l'utente è loggato e ha ruolo admin, viene reindirizzato alla pagina admin
  # Altrimenti viene reindirizzato alla pagina dei menu
  def index
    if user_signed_in? && (!current_user.completed? || current_user.completed < 2)
      redirect_to new_complete_registration_path
    elsif user_signed_in? && current_user.admin?
      redirect_to profiles_path
    elsif user_signed_in? && current_user.chef?
      redirect_to profile_path(current_user)
    else
      redirect_to menus_path
    end
  end
end
