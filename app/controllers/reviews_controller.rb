class ReviewsController < ApplicationController
    before_action :authenticate_user!

    # Il cliente crea una recensione allo chef (val) e al menu (val + commento)
    def create_by_client
        prenotazione = Reservation.find(review_params[:prenotazione_id])
        if prenotazione.reviews.pluck(:tipo_recensione_type).include?("Chef") || prenotazione.reviews.pluck(:tipo_recensione_type).include?("Menu")
          flash[:alert] = "Recensione già creata, non puoi crearne un'altra."
          redirect_to prenotazione
        else
          recensione_al_chef = prenotazione.reviews.build({ valutazione: review_params[:valutazione_chef], tipo_recensione: prenotazione.chef })
          recensione_al_menu = prenotazione.reviews.build({ valutazione: review_params[:valutazione_menu], commento: review_params[:commento], tipo_recensione: prenotazione.menu })
          if prenotazione.save
            flash[:notice] = "Recensione creata con successo."
            redirect_to prenotazione
          else
            # Print error messages
            flash[:error] = "Errore. Recensione non creata."
            redirect_to prenotazione
          end
        end
    end

    # Lo chef crea una recensione al cliente (val)
    def create_by_chef
        prenotazione = Reservation.find(review_params[:prenotazione_id])
        if prenotazione.reviews.pluck(:tipo_recensione_type).include?("Client")
            flash[:alert] = "Recensione già creata, non puoi crearne un'altra."
           redirect_to prenotazione
        else
            recensione_al_cliente = prenotazione.reviews.build({ valutazione: review_params[:valutazione_cliente], tipo_recensione: prenotazione.client })
            if prenotazione.save
                flash[:notice] = "Recensione creata con successo."
                redirect_to prenotazione
            else
                flash[:error] = "Errore. Recensione non creata."
                redirect_to prenotazione
            end
        end
    end
    private

    def review_params
        params.require(:review).permit(:valutazione_menu, :valutazione_chef, :commento, :prenotazione_id, :valutazione_cliente)
    end
end
