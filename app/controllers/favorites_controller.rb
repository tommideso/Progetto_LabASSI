class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_client

  def update
      @menu = Menu.find(params[:id])
      # Se il menu è già nei preferiti, lo rimuove, altrimenti lo aggiunge
      favorite = Favorite.where(menu: @menu, client: current_user.client)
      if favorite.empty?
        Favorite.create!(menu: @menu, client: current_user.client)
        @favorite_exists = true
        flash[:notice] = "Menu aggiunto ai preferiti"
      else
        favorite.destroy_all
        @favorite_exists = false
        flash[:notice] = "Menu rimosso dai preferiti"
      end
      redirect_to @menu, anchor: "favorite-button"
  end

  def index
    @favorites = current_user.client.favorites
  end
end
