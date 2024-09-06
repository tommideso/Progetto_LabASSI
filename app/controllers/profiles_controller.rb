class ProfilesController < ApplicationController

    def show 
        @user = User.find(params[:id])
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
