class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_client

  def update
      menu = Menu.find(params[:menu])
      # Se il menu è già nei preferiti, lo rimuove, altrimenti lo aggiunge
      favorite = Favorite.where(menu: menu, client: current_user.client)
      if favorite.empty?
        Favorite.create!(menu: menu, client: current_user.client)
        @favorite_exists = true
      else
        favorite.destroy_all
        @favorite_exists = false
      end

      respond_to do |format|
        format.html { redirect_to menu }
        format.js { }
      end
  end

  def index
    @favorites = current_user.client.favorites
  end
end
