class MenusController < ApplicationController
    before_action :find_menu, only: [:show]

    def index
        @menu = Menu.all
    end

    def show
    end

    def new
        @menu = Menu.new
    end

    # def create
    #     @menu = BlogPost.new(params_blog_post)
    #     if @post.save
    #         redirect_to @post
    #     else
    #         render :new, status: :unprocessable_entity
    #     end
    # end

    private
    def find_menu
        @menu = Menu.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            redirect_to root_path 
    end
end 