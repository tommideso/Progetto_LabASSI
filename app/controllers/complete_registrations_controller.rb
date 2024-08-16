class CompleteRegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def new
    if @user.ruolo == "chef"
      @chef = Chef.find_or_initialize_by(user: @user)
    elsif @user.ruolo == "client"
      @client = Client.find_or_initialize_by(user: @user)
    end
  end

  def create
    if @user.ruolo == "chef"
      @chef = Chef.find_or_initialize_by(user: @user)
      if @chef.update(chef_params) && @user.update(user_params)
        redirect_to root_path, notice: 'Profilo chef completato con successo.'
      else
        Rails.logger.debug "Chef errors: #{@chef.errors.full_messages}"
        Rails.logger.debug "User errors: #{@user.errors.full_messages}"
        render :new, status: :unprocessable_entity
      end
    elsif @user.ruolo == "client"
      @client = Client.find_or_initialize_by(user: @user)
      if @client.update(client_params) && @user.update(user_params)
        redirect_to root_path, notice: 'Profilo client completato con successo.'
      else
        Rails.logger.debug "Client errors: #{@client.errors.full_messages}"
        Rails.logger.debug "User errors: #{@user.errors.full_messages}"
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to root_path, alert: 'Ruolo utente non valido.'
    end
  end

  private

  def set_user
    @user = current_user
  end

  def chef_params
    params.require(:chef).permit(:indirizzo, :telefono, :raggio, :descrizione)
  end

  def client_params
    params.require(:client).permit(:indirizzo, :telefono, :allergeni)
  end

  def user_params
    params.require(:user).permit(:nome, :cognome)
  end
end
