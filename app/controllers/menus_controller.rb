class MenusController < ApplicationController
    before_action :find_menu, only: [ :show, :edit, :update, :destroy ]
    # prima di accedere alle funzioni di modifica o creazione di un menù l'utente deve essere autenticato
    before_action :authenticate_user!, only: [ :edit, :update, :destroy, :new, :create ]
    # oltre ad essere autenticato, il suo ruolo deve essere quello di chef
    before_action :check_if_chef, only: [ :edit, :update, :destroy, :new, :create ]
    # attiva,disattiva menu
    before_action :check_permission, only: [ :disattiva, :riattiva ]

    def index
        page = params[:page].to_i
        page = 1 if page <= 0

        # Filtra solo i menu attivi
        total_items = Menu.where(disattivato: false).count
        num_items = 10
        @total_pages = (total_items.to_f / num_items).ceil

        puts "Total items: #{total_items}, total pages: #{@total_pages}"
        # Se la pagina richiesta supera il numero totale di pagine, non caricare nulla
        if page > @total_pages
          render turbo_stream: turbo_stream.replace("menu-list", "") and return
        end

        # Fa vedere solo menu attivi (da far vedere a admin)
        @pagy, @menus = pagy(Menu.where(disattivato: false), page: page, items: num_items)
        respond_to do |format|
            format.html
            format.turbo_stream
        end
    end


    def show
        # Se il menu è disattivato, solo l'admin o lo chef che l'ha disattivato possono vederlo
        unless !@menu.disattivato || user_signed_in? && (current_user.admin? || (current_user.chef? && @menu.chef == current_user.chef))
            flash[:error] = "Questo menu è stato disattivato e quindi non è visibile."
            redirect_to root_path
        end

        if user_signed_in?
            if current_user.client?
              # Controllo se il menù è già tra i preferiti dell'utente
              @favorite_exists = Favorite.where(menu: @menu, client: current_user.client) == []? false : true
              disabled_dates_client = current_user.client.reservations.where(stato: [ :confermata, :attesa_pagamento ]).pluck(:data_prenotazione)
              disabled_dates_chef = @menu.chef.reservations.where(stato: [ :confermata, :attesa_pagamento ]).pluck(:data_prenotazione)
              @disabled_dates = (disabled_dates_client + disabled_dates_chef).map { |date| date.strftime("%Y-%m-%d") }

            end
        end

        # Recensioni
        @menu_reviews = @menu.reservations.map { |r| r.reviews }.flatten.select { |r| r.tipo_recensione_type == "Menu" }
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
            flash[:notice] = "Menu aggiornato con successo"
            redirect_to @menu

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

    # Attiva e disattiva menu
    def disattiva
        @menu = Menu.find(params[:id])
        if current_user.chef?
          @menu.update(disattivato: true, disattivato_da: "chef")
        elsif current_user.admin?
          @menu.update(disattivato: true, disattivato_da: "admin")
        end
        flash[:notice] = "Menu disattivato con successo."
        redirect_to @menu
    end

    def riattiva
        @menu = Menu.find(params[:id])
        if @menu.disattivato_da == current_user.ruolo
            @menu.update(disattivato: false, disattivato_da: nil)
            flash[:notice] = "Menu riattivato con successo."
            redirect_to @menu
        else
            flash[:alert] = "Non puoi riattivare un menu disattivato da un altro ruolo."
            redirect_to @menu
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
            images: [], dishes_attributes: [ :id, :nome, :tipo_portata, :ingredienti, :_destroy ]
          )
    end

    def check_permission
        @menu = Menu.find(params[:id])
        # Controlla se l'utente ha il permesso di disattivare/riattivare il menu
        if current_user.chef? && @menu.disattivato_da == "admin"
            flash[:error] = "Non puoi disattivare un menu disattivato dall'admin."
            redirect_to menus_path
        elsif current_user.admin? && @menu.disattivato_da == "chef"
            flash[:error] = "Non puoi disattivare un menu disattivato dallo chef."
            redirect_to menus_path
        end
    end
end
