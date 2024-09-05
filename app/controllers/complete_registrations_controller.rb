class CompleteRegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def new
    if @user.completed == 2 # Profilo completato
      redirect_to root_path, notice: "Profilo già completato."
    elsif @user.completed == 1 # Ruolo selezionato
      @chef = @user.chef || @user.build_chef if @user.chef?
      @client = @user.client || @user.build_client if @user.client?
      clean_url_from_role_param_and_redirect
    elsif params[:role] # Ruolo cliccato nel form
        if params[:role] == "chef" || params[:role] == "client"
          @user.update(ruolo: params[:role])
          @user.update_column(:completed, 1)
          # sfruttiamo la notazione nestata (client e chef vengono considerati 'dentro' user)
          @chef = @user.chef || @user.build_chef if params[:role] == "chef"
          @client = @user.client || @user.build_client if params[:role] == "client"
          clean_url_from_role_param_and_redirect
        else
          redirect_to new_complete_registration_path, alert: "Ruolo non valido."
        end
    else
      render :role_selection
    end
  end

  def create
    if @user.update(user_params)
      @user.update_column(:completed, 2)
      redirect_to root_path, notice: "Profilo completato con successo."
    else
      # se la validazione fallisce, ri-inizializziamo gli attributi nestati (chef e client)
      @chef = @user.chef if @user.chef?
      @client = @user.client if @user.client?
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:nome, :cognome, :ruolo, :completed,
    chef_attributes: [ :indirizzo, :telefono, :raggio, :descrizione, :id ],
    client_attributes: [ :indirizzo, :telefono, { allergeni: {} }, :id ])
  end
  def clean_url_from_role_param_and_redirect
    if params[:role].present? # Se il ruolo è stato selezionato, tolgo il parametro role dall'url per renderlo clean
      clean_params = request.query_parameters.except(:role)
      redirect_to new_complete_registration_path(clean_params) and return
    end
  end
end
