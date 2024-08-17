class MenusController < ApplicationController
    before_action :find_menu, only: [:show, :edit, :update, :destroy]

    def index
        @menu = Menu.all
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
            Rails.logger.debug "Failed to edit menu: #{@menu.errors.full_messages.join(', ')}"
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
end 