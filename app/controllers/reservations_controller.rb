class ReservationsController < ApplicationController
    before_action :authenticate_user!

  
    def create
      PaperTrail.request(enabled: true) do
        @reservation = Reservation.new(reservation_params)
        @reservation.stato = 'pending'
        @reservation.data_prenotazione = Date.today
    
        if @reservation.save
          redirect_to @reservation, notice: 'Reservation was successfully created.'
        else
          logger.error @reservation.errors.full_messages.join(", ")
          redirect_to menu_path(reservation_params[:menu_id]), alert: 'Failed to create reservation.'
        end
      end
    end
  
    def show
      @reservation = Reservation.find(params[:id])
      @review = Review.new
    end

    def index
      if current_user.chef?
        @reservations = Reservation.where(chef_id: current_user.chef.id)
      elsif current_user.client?
        @reservations = Reservation.where(client_id: current_user.client.id)
      end
    end

  
    private
  
    def reservation_params
      params.require(:reservation).permit(:client_id, :chef_id, :prezzo, :num_persone, :tipo_pasto, :extra, :menu_id)
    end
  end