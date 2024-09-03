class ReviewsController < ApplicationController
    before_action :authenticate_user!
    # Il cliente crea una recensione allo chef (val) e al menu (val + commento) 
    def create_by_client
        prenotazione = Reservation.find(review_params[:prenotazione_id])
        recensione_allo_chef = prenotazione.reviews.build({valutazione: review_params[:valutazione_chef], tipo_recensione: prenotazione.chef})
        recensione_al_menu = prenotazione.reviews.build({valutazione: review_params[:valutazione_menu], tipo_recensione: prenotazione.menu, commento: review_params[:commento]})
        if prenotazione.save
            redirect_to prenotazione, notice: 'Recensione creata con successo.'
        else
            redirect_to prenotazione, alert: 'Errore. Recensione non creata.'
        end
    end

    # Lo chef crea una recensione al cliente (val)
    def create_by_chef
        prenotazione = Reservation.find(review_params[:prenotazione_id])	
        recensione_al_cliente = prenotazione.reviews.build({valutazione: review_params[:valutazione_chef], tipo_recensione: prenotazione.client})
        if prenotazione.save
            redirect_to prenotazione, notice: 'Recensione creata con successo.'
        else
            redirect_to prenotazione, alert: 'Errore. Recensione non creata.'
        end
    end
    private

    def review_params
        params.require(:review).permit(:valutazione_menu, :valutazione_chef, :commento, :prenotazione_id)
    end
end
