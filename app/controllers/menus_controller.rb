class MenusController < ApplicationController
    before_action :find_menu, only: [ :show, :edit, :update, :destroy, :versions, :show_version ]
    # prima di accedere alle funzioni di modifica o creazione di un menù l'utente deve essere autenticato
    before_action :authenticate_user!, only: [ :edit, :update, :destroy, :new, :create ]
    # oltre ad essere autenticato, il suo ruolo deve essere quello di chef
    before_action :check_if_chef, only: [ :edit, :update, :destroy, :new, :create ]
    # attiva,disattiva menu
    before_action :check_permission, only: [ :disattiva, :riattiva ]


    # Altro metodo funzionante per infinite scroll, con rescue per evitare errori
    # def index
    #     # Default to page 1 if params[:page] is not a valid positive integer
    #     page = params[:page].to_i
    #     page = 1 if page <= 0
    #     num_items = 10 # Number of items per page
    #     begin
    #         @pagy, @menu = pagy(Menu.all, page: page, items: num_items)
    #         rescue Pagy::OverflowError
    #         return
    #     end

    #     respond_to do |format|
    #     format.html # Renders the HTML view by default
    #     format.turbo_stream # Handles Turbo Stream format
    #     end

    #   end

    def index
        page = params[:page].to_i
        page = 1 if page <= 0
        num_items = 10

        # Filtra solo i menu attivi
        total_items = Menu.where(disattivato: false).count
        total_pages = (total_items.to_f / num_items).ceil

        # Se la pagina richiesta supera il numero totale di pagine, non caricare nulla
        if page > total_pages
          render turbo_stream: turbo_stream.replace("menu-container", "") and return
        end

        # Fa vedere solo menu attivi (da far vedere a admin)
        @pagy, @menus = pagy(Menu.where(disattivato: false), page: page, items: num_items)

        respond_to do |format|
          format.html
          format.turbo_stream
        end
    end


    def show
        if user_signed_in? && current_user.client?
            # Controllo se il menù è già tra i preferiti dell'utente
            @favorite_exists = Favorite.where(menu: @menu, client: current_user.client) == []? false : true
            disabled_dates_client = current_user.client.reservations.where(stato: [ :confermata, :attesa_pagamento ]).pluck(:data_prenotazione)
            disabled_dates_chef = @menu.chef.reservations.where(stato: [ :confermata, :attesa_pagamento ]).pluck(:data_prenotazione)
            @disabled_dates = (disabled_dates_client + disabled_dates_chef).map { |date| date.strftime("%Y-%m-%d") }
        end
    end

    def new
        @menu = Menu.new
    end

    def edit
    end

    def update
        # Se prezzo_persona è cambiato, aggiorno il prezzo del prodotto su Stripe
        old_price = @menu.prezzo_persona
        update_params = menu_params.dup
        begin
            if menu_params[:prezzo_persona].to_f != old_price.to_f
                product = Stripe::Price.create({
                    unit_amount: (menu_params[:prezzo_persona].to_f * 100).to_i,
                    product: @menu.stripe_product_id,
                    currency: "eur"
                })
                update_params[:stripe_price_id] = product.id
            end
        rescue Stripe::StripeError => e
            @menu.errors.add(:base, "Errore durante l'aggiornamento del prezzo (Stripe): #{e.message}")
        end

        if @menu.update(update_params)
            begin
                Stripe::Product.update(@menu.stripe_product_id, {
                    name: @menu.titolo,
                    description: @menu.descrizione
                })
            rescue Stripe::StripeError => e
                Rails.logger.error "Errore durante l'aggiornamento del prodotto: #{e.message}"
            end
            redirect_to @menu, notice: "Menu aggiornato con successo"

        else
            render :edit, status: :unprocessable_entity
        end
    end

    def create
        @menu = Menu.new(menu_params)
        @menu.chef = current_user.chef
        begin
            product = Stripe::Product.create({
                name: @menu.titolo,
                active: true,
                description: @menu.descrizione,
                metadata: {
                    menu_id: @menu.id
                }
            })
            price = Stripe::Price.create({
                product: product.id,
                unit_amount: (@menu.prezzo_persona * 100).to_i,
                currency: "eur"
            })
            @menu.stripe_product_id = product.id
            @menu.stripe_price_id = price.id
        rescue Stripe::StripeError => e
            @menu.errors.add(:base, "Errore durante la creazione del prodotto o del prezzo (Stripe): #{e.message}")
        end
        if @menu.save
            redirect_to @menu
        else
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        if @menu.destroy
            redirect_to root_path
        else
            render :show, status: :unprocessable_entity
        end
    end

    # Funzione per rimuovere un'immagine (richiesta delete da pulsante in _form.html.erb sotto ogni immagine)
    def remove_image
        @image = ActiveStorage::Attachment.find(params[:id])
        @image.purge_later
        redirect_back(fallback_location: request.referer)
    end

    # metodi per accedere alle versioni
    def versions
        @versions = @menu.versions
    end

    # per mostrare una versione specifica
    def show_version
        @menu = @menu.versions.find(params[:version_id]).reify
        @version = @menu.versions.find(params[:version_id])
    end

    # Attiva e disattiva menu
    def disattiva
        @menu = Menu.find(params[:id])
        if current_user.chef?
          @menu.update(disattivato: true, disattivato_da: "chef")
        elsif current_user.admin?
          @menu.update(disattivato: true, disattivato_da: "admin")
        end
        redirect_to @menu, notice: "Menu disattivato con successo."
    end

    def riattiva
        @menu = Menu.find(params[:id])
        if @menu.disattivato_da == current_user.ruolo
            @menu.update(disattivato: false, disattivato_da: nil)
            redirect_to @menu, notice: "Menu riattivato con successo."
        else
            redirect_to @menu, alert: "Non puoi riattivare un menu disattivato da un altro ruolo."
        end
    end

    private

    def find_menu
        @menu = Menu.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to root_path
    end

    def menu_params
        # non permetto il passaggio del parametro disattivato! (solo per gli admin, per questioni di sicurezza)
        params.require(:menu).permit(
            :titolo, :descrizione, :prezzo_persona, :min_persone, :max_persone, :tipo_cucina, :prezzo_extra,
            allergeni: {}, preferenze_alimentari: {}, adattabile: [ preferenze: {}, allergeni: {} ], extra: {},
            images: []
          )
    end

    def check_permission
        @menu = Menu.find(params[:id])
        # Controlla se l'utente ha il permesso di disattivare/riattivare il menu
        if current_user.chef? && @menu.disattivato_da == "admin"
          redirect_to menus_path, alert: "Non puoi modificare un menu disattivato dall'admin."
        elsif current_user.admin? && @menu.disattivato_da == "chef"
          redirect_to menus_path, alert: "Non puoi modificare un menu disattivato dallo chef."
        end
    end
end
