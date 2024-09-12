class ProfilesController < ApplicationController
    before_action :authenticate_user!, only: [ :block, :unblock, :index ]
    before_action :check_if_admin, only: [ :block, :unblock, :index ]

    # Ho già controllo se l'utente è admin
    def index
        @users = User.all
        @chefs = @users.where(ruolo: "chef")
        @clients = @users.where(ruolo: "client")
    end

    def show
        @user = User.find(params[:id])
        if @user.admin?
            flash[:alert] = "Non puoi vedere il profilo di un amministratore"
            redirect_to root_path
            return
        end
        # solo se l'utente è uno chef voglio vedere i suoi menu
        if @user.chef?
            @menus = Menu.where(chef: @user.chef).order(created_at: :desc).limit(5)
        end
        # il profilo di un cliente può essere visto solo dall'admin o dal cliente stesso
        if @user.client?
            if !current_user.admin? && current_user.id != @user.id
                redirect_to root_path
                return
            end
        end
        @reservations = (@user.chef? ? @user.chef.reservations : @user.client.reservations).order(created_at: :desc).limit(5)
        reviews = @user.chef? ? @user.chef.reviews : @user.client.reviews
        puts reviews.map { |r| r.valutazione.to_f }
        # Voglio controllare il tipo delle recensioni e metterlo in un array
        @reviews_average = reviews.map { |r| r.valutazione.to_f }
        puts "AAAAAAAAAAAAAAA #{@reviews_average}"
        @reviews_average = @reviews_average.size > 0 ? (@reviews_average.sum / @reviews_average.size).round(2) : nil
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
