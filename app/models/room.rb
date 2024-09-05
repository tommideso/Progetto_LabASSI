class Room < ApplicationRecord
    # le stanze devono avere un id univoco
    validates_uniqueness_of :name
    # vincoli necessari per la chat
    has_many :messages, dependent: :destroy
    has_many :participants, dependent: :destroy

    def self.create_room(users, room_name)
        # creiamo la stanza
        single_room = Room.create(name: room_name)
        # per ogni utente (2) che partecipa alla stanza, lo aggiungiamo ai partecipant
        users.each do |user|
          Participant.create(user_id: user.id, room_id: single_room.id)
        end
        # restituiamo la stanza
        single_room
    end
end
