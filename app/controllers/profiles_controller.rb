class ProfilesController < ApplicationController
    before_action :authenticate_user!, only: [ :block, :unblock, :index, :reservations ]
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
            @menus = Menu.where(chef: @user.chef).order(created_at: :desc).limit(4)
        end
        # il profilo di un cliente può essere visto solo dall'admin o dal cliente stesso
        if @user.client?
            if !current_user.admin? && current_user.id != @user.id
                redirect_to root_path
                return
            end
        end
        @reservations = (@user.chef? ? @user.chef.reservations : @user.client.reservations).order(created_at: :desc).limit(3)
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

    # Mostro i menu di uno chef
    def menus
        @user = User.find(params[:id])
        if @user.client?
            flash[:alert] = "Un cliente non può avere menu"
            redirect_to root_path
            return
        end
        if user_signed_in? && (current_user.id == @user.id || current_user.admin?)
            @menus = Menu.where(chef: @user.chef).order(created_at: :desc)
        else
            # Se l'utente non è loggato o non è l'utente giusto, mostro solo i menu attivi
            @menus = Menu.where(chef: @user.chef).where(disattivato: false).order(created_at: :desc)
        end
        render "menus/index"
    end

    # Mostro le prenotazioni di un utente
    def reservations
        @user = User.find(params[:id])
        if !current_user.admin? && current_user.id != @user.id
            flash[:alert] = "Non hai i permessi necessari per vedere questa pagina"
            redirect_to root_path
            return
        end
        @reservations = (@user.chef? ? @user.chef.reservations : @user.client.reservations).order(created_at: :desc)
        @next_reservations = @reservations.where("data_prenotazione >= ?", Date.today).where(stato: [ :attesa_pagamento, :confermata ]).order(data_prenotazione: :asc)
        @cancelled_reservations = @reservations.where(stato: [ :cancellata ]).order(data_prenotazione: :desc)
        @completed_reservations = @reservations.where(stato: [ :completata, :rimborsata ]).order(data_prenotazione: :desc)
        render "reservations/index"
    end
end
