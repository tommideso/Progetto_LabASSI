class RoomsController < ApplicationController
  # per accedere ad una stanza bisogna essere ovviamente autenticati
  before_action :authenticate_user!

  def index
    @room = Room.new
    # TODO: rimuovere
    @users = User.all_except(current_user)
    render "index"
  end

  def create
    # creiamo la stanza dandogli il nome associato alla chiave room dentro params
    @room = Room.create(name: params["room"]["name"])
  end

  def show
    # troviamo la stanza con il relativo id
    @single_room = Room.find(params[:id])
    @room = Room.new

    # inizializziamo i messaggi e li mostriamo in ordine ascendente
    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)

    # TODO: rimuovere
    @users = User.all_except(current_user)
    render "index"
  end
end
