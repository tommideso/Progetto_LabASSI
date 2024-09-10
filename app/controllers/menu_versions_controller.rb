class MenuVersionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_menu, only: [ :show, :index ]
  before_action :check_if_admin, only: [ :index ]
  def show
    @menu = @menu.versions.find(params[:id]).reify
    @version = @menu.versions.find(params[:id])
  end

  def index
     @versions = @menu.versions
     puts "AAAAAAAAAAAAA"
      puts @versions.inspect
      puts "AAAAAAAAAAAAA"
  end

  private
  def find_menu
    @menu = Menu.find(params[:menu_id])
  end
end
