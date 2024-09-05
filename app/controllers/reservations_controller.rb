class ReservationsController < ApplicationController
  before_action :authenticate_user!


  def create
    PaperTrail.request(enabled: true) do
      @reservation = Reservation.new(reservation_params)

      @reservation.data_prenotazione = Faker::Date.forward(from: Date.today, days: 10)
      # TODO: mettere indirizzo vero
      @reservation.indirizzo_consegna = current_user.client.indirizzo
      if @reservation.save
        redirect_to @reservation, notice: "Reservation was successfully created."
      else
        puts "ERRORE PRENOTAZIONE"
        logger.error @reservation.errors.full_messages.join(", ")
        redirect_to menu_path(reservation_params[:menu_id]), alert: "Impossibile creare la prenotazione, controlla il log per ulteriori dettagli."
      end
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
    @review = Review.new
    if current_user.client?
      if @reservation.pagamento_effettuato == false
        current_user.client.set_payment_processor :stripe
        current_user.client.payment_processor.customer
        menu = @reservation.menu.versions.find(@reservation.menu_version_id).reify
        @checkout_session = current_user.client.payment_processor.checkout(
            mode: "payment",
            line_items: [ {
              price: menu.stripe_price_id,
              quantity: @reservation.num_persone
            },
            {
              price: menu.stripe_price_id,
              quantity: 1
            } ],
            metadata: {
              reservation_id: @reservation.id
            },
            success_url: checkout_success_reservation_url(@reservation),
            cancel_url: reservation_url(@reservation)
          )
      end
    end
  end

  def index
    if current_user.chef?
      @reservations = Reservation.where(chef_id: current_user.chef.id)
    elsif current_user.client?
      @reservations = Reservation.where(client_id: current_user.client.id)
    end
  end

  def checkout_success
    session_id = params[:session_id]
    begin
      session = Stripe::Checkout::Session.retrieve(session_id)
      payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent)

      if payment_intent.status == "succeeded"
        reservation = Reservation.find(params[:id])
        reservation.pagamento_effettuato = true
        reservation.stripe_session_id = session_id
        reservation.stato = :confermata
        if reservation.save
          # Invia una mail di conferma se necessario
          redirect_to reservation, notice: "Pagamento effettuato con successo."
        else
          puts "Errore nel salvataggio della prenotazione"
          logger.error reservation.errors.full_messages.join(", ")
          redirect_to reservation, alert: "Impossibile salvare la prenotazione."
        end
      else
        redirect_to reservation, alert: "Pagamento non riuscito."
      end
    rescue Stripe::StripeError => e
      redirect_to reservation, alert: "Errore durante il pagamento: #{e.message}"
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:client_id, :chef_id, :prezzo, :num_persone, :tipo_pasto, :extra, :menu_id)
  end
end
