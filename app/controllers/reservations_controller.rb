class ReservationsController < ApplicationController
  before_action :authenticate_user!
  # Controllo che l'utente sia il cliente o il cuoco della prenotazione, oppure un admin
  # nelle azioni show e destroy (azioni che riguardano una singola prenotazione)
  before_action :check_user_permission, only: [ :show, :destroy ]

  def index
    if current_user.chef?
      @reservations = Reservation.where(chef_id: current_user.chef.id)
    elsif current_user.client?
      @reservations = Reservation.where(client_id: current_user.client.id)
    elsif current_user.admin?
      @reservations = Reservation.all
    end
  end



  def show
    @reservation = Reservation.find(params[:id])
    @review = Review.new
    puts "RESERVATION: #{@reservation.data_prenotazione}, #{Date.today}, #{@reservation.data_prenotazione > Date.today}"
    if @reservation.data_prenotazione < Date.today && @reservation.confermata?
      @reservation.stato = :completata
    elsif @reservation.data_prenotazione < Date.today && @reservation.attesa_pagamento?
      @reservation.stato = :cancellata
    end
    if current_user.client?
      if @reservation.attesa_pagamento?
        current_user.client.set_payment_processor :stripe
        current_user.client.payment_processor.customer
        menu = @reservation.menu.versions.find(@reservation.menu_version_id).reify
        @checkout_session = current_user.client.payment_processor.checkout(
            mode: "payment",
            line_items: [ {
              price: menu.stripe_price_id,
              quantity: @reservation.num_persone
            }
              # {
              #   price: menu.stripe_price_id,
              #   quantity: 1
              # }
              # TODO aggiungere extra
            ],
            metadata: {
              reservation_id: @reservation.id
            },
            success_url: checkout_success_reservation_url(@reservation),
            cancel_url: reservation_url(@reservation)
          )
      end
    end
  end

  def create
    if current_user.client?
      puts "PARAMS: #{reservation_params.inspect}"

      menu = Menu.find(reservation_params[:menu_id])
      update_params = reservation_params.dup
      update_params[:client_id] = current_user.client.id
      update_params[:chef_id] = menu.chef.id

      PaperTrail.request(enabled: true) do
        @reservation = Reservation.new(update_params)
        # TODO aggiungere anche extra
        @reservation.prezzo = menu.prezzo_persona.to_f * reservation_params[:num_persone].to_i
        if @reservation.save
          redirect_to @reservation, notice: "Reservation was successfully created."
        else
          puts "ERRORE PRENOTAZIONE"
          logger.error @reservation.errors.full_messages.join(", ")
          redirect_to menu_path(reservation_params[:menu_id]), alert: "Impossibile creare la prenotazione, controlla il log per ulteriori dettagli."
        end
      end
    end
  end

  def checkout_success
    session_id = params[:session_id]
    begin
      session = Stripe::Checkout::Session.retrieve(session_id)
      payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent)

      if payment_intent.status == "succeeded"
        reservation = Reservation.find(params[:id])
        reservation.stripe_payment_intent_id = session.payment_intent
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

  def destroy
    puts "PARAMS: #{params.inspect}"
    @reservation = Reservation.find(params[:id])
    if @reservation.attesa_pagamento?
      @reservation.stato = :cancellata
    elsif @reservation.confermata?
      @reservation.stato = :cancellata
      refund_payment(@reservation)
    elsif @reservation.completata?
      @reservation.stato = :rimborsata
      refund_payment(@reservation)
    else
      # Non si può cancellare una prenotazione rimborsata o cancellata
      redirect_to @reservation, alert: "Impossibile cancellare la prenotazione, controlla lo stato della prenotazione."
    end
    if @reservation.save
      redirect_to @reservation, notice: "Prenotazione cancellata con successo."
    else
      redirect_to @reservation, alert: "Impossibile cancellare la prenotazione."
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:num_persone, :tipo_pasto, :extra, :menu_id, :data_prenotazione, :indirizzo_consegna)
  end

  def refund_payment(reservation)
    begin
      payment_intent = Stripe::PaymentIntent.retrieve(reservation.stripe_payment_intent_id)
      Stripe::Refund.create({
        payment_intent: payment_intent.id
      })
    rescue Stripe::StripeError => e
      logger.error "Errore durante il rimborso: #{e.message}"
      redirect_to reservation, alert: "Errore durante il rimborso: #{e.message}"
    end
  end

  def check_user_permission
    reservation = Reservation.find(params[:id])
    unless current_user.client && reservation.client == current_user.client ||
      current_user.chef && reservation.chef == current_user.chef ||
      current_user.admin?
      redirect_to reservations_path, alert: "Non hai i permessi necessari per visualizzare questa prenotazione."
    end
  end
end
