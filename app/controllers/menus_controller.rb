class MenusController < ApplicationController

    before_action :find_menu, only: [:show, :edit, :update, :destroy]
    # prima di accedere alle funzioni di modifica o creazione di un menù l'utente deve essere autenticato
    before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :create]
    # oltre ad essere autenticato, il suo ruolo deve essere quello di chef
    before_action :check_if_chef, only: [:edit, :update, :destroy, :new, :create]
    
 
    
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
      
        # Calcola il numero totale di elementi e il numero di pagine
        total_items = Menu.count
        total_pages = (total_items.to_f / num_items).ceil            
      
        # Se la pagina richiesta supera il numero totale di pagine, non caricare nulla
        if page > total_pages
          render turbo_stream: turbo_stream.replace("menu-container", "") and return
        end
      
        @pagy, @menu = pagy(Menu.all, page: page, items: num_items)
      
        respond_to do |format|
          format.html
          format.turbo_stream
        end
      end
   

    def show
    end

    def new
        @menu = Menu.new
    end

    def edit
    end

    def update
        if @menu.update(menu_params)
            redirect_to @menu
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def create
        @menu = Menu.new(menu_params)
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
            allergeni: {}, preferenze_alimentari: {}, adattabile: [:preferenze => {}, :allergeni => {}], extra: {}
          )
    end

    def check_if_chef
        unless current_user.ruolo == "chef"
            redirect_to root_path, alert: "Il ruolo non consente tale azione"
        end
    end

    
      
end 