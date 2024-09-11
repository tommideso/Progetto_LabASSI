class ProfilesController < ApplicationController
    before_action :check_if_admin, only: [ :block, :unblock, :index ]

    # Ho già controllo se l'utente è admin
    def index
        @users = User.all
        @chefs = @users.where(ruolo: "chef")
        @clients = @users.where(ruolo: "client")
    end

    def show
        @user = User.find(params[:id])
        # solo se l'utente è uno chef voglio vedere i suoi menu
        if @user.admin?
            flash[:alert] = "Non puoi vedere il profilo di un amministratore"
            redirect_to root_path
            return
        end
        if @user.chef?
            @menus = Menu.where(chef: @user.chef)
        end
        @reservations = @user.chef? ? @user.chef.reservations : @user.client.reservations
        reviews = @user.chef? ? @user.chef.reviews : @user.client.reviews
        puts reviews.map { |r| r.valutazione.to_f }
        # Voglio controllare il tipo delle recensioni e metterlo in un array
        @reviews_average = reviews.map { |r| r.valutazione.to_f }
        @reviews_average = @reviews_average.sum / @reviews_average.size if @reviews_average.size > 0
    end

    # Ci arrivo da richiesta PUT a /profiles/:id/block
    def block
        @user = User.find(params[:id])
        if !@user.admin?
            @user.lock_access!
            flash[:notice] = "Utente bloccato"
        else
            flash[:alert] = "Non puoi bloccare un amministratore"
        end
        redirect_to profile_path(@user.id)
    end

    # Ci arrivo da richiesta PUT a /profiles/:id/unblock
    def unblock
        @user = User.find(params[:id])
        @user.unlock_access!
        flash[:notice] = "Utente sbloccato"
        redirect_to profile_path(@user.id)
    end
end
