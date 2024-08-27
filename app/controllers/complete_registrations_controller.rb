class CompleteRegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def new
    if (params[:role])
      @user.update(ruolo: params[:role])
      @user.update_column(:completed, 1)
      # sfruttiamo la notazione nestata (client e chef vengono considerati 'dentro' user)
      @chef = @user.chef || @user.build_chef if params[:role] == 'chef'
      @client = @user.client || @user.build_client if params[:role] == 'client'
    elsif (@user.completed == 1)
      @chef = @user.chef || @user.build_chef if @user.chef?
      @client = @user.client || @user.build_client if @user.client?
    else
      render :role_selection
    end
  end

  def create
    if @user.update(user_params)
      @user.update(completed: 2)
      redirect_to root_path, notice: 'Profilo completato con successo.'
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
    chef_attributes: [:indirizzo, :telefono, :raggio, :descrizione, :id], 
    client_attributes: [:indirizzo, :telefono, { allergeni: {} }, :id])
  end
end