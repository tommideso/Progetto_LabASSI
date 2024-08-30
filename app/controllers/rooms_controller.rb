class RoomsController < ApplicationController
  # per accedere ad una stanza bisogna essere ovviamente autenticati
  before_action :authenticate_user!

  def index
    @room = Room.new
    # TODO: rimuovere
    @users = User.all_except(current_user)
    render 'index'
  end
end
