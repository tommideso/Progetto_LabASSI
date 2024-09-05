class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) # l'utente che abbiamo selezionato
    # TODO: RIMUOVERE quando avremo fatto la schermata di creazione di una chat
    @users = User.all_except(current_user) # tutti gli utenti tranne l'attuale

    # questa funzione crea la nuova stanza (dal punto di vista del modello) prende il nome della stanza
    # e controlla se esiste già una stanza con quel nome: se non esiste, viene creata
    create_or_retrive_single_room

    # poi mostro i messaggi in ordine ascendente
    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)
    # e renderizzo la stanza
    render "rooms/index"
  end


  private

  def create_or_retrive_single_room
    @room = Room.new
    # per ottenere il nome utilizziamo una funzione che calcoli in maniera univoca un nome a partire dall'id di entrambi gli utenti
    @room_name = get_room_name(@user, current_user)
    # se la stanza non esiste, la creiamo
    @single_room = Room.where(name: @room_name).first || Room.create_room([ @user, current_user ], @room_name)
  end

  def get_room_name(user1, user2)
    user = [ user1, user2 ].sort
    "private_#{user[0].id}_#{user[1].id}"
  end
end
