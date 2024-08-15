class MenusController < ApplicationController
    before_action :find_menu, only: [:show]

    def index
        @menu = Menu.all
    end

    def show
    end

    private
    def find_menu
        @menu = Menu.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            redirect_to root_path 
    end
end 