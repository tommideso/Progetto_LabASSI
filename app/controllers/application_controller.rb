class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include Pagy::Backend 

  before_action :set_query

  def set_query
    @q=Menu.ransack(params[:q])   
  end


end
