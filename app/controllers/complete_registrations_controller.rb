class CompleteRegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def new
    @chef = Chef.find_or_initialize_by(user: @user) if @user.chef?
    @client = Client.find_or_initialize_by(user: @user) if @user.client?
  end

  def create
    if @user.update(user_params)
      redirect_to root_path, notice: 'Profilo completato con successo.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:nome, :cognome, chef_attributes: [:indirizzo, :telefono, :raggio, :descrizione], client_attributes: [:indirizzo, :telefono, :allergeni])
  end
end