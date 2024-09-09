class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  # prima di creare un messaggio confermiamo i partecipanti alla stanza
  before_create :confirm_participant
  # fondamentale affinché ogni messaggio porti ad un aggiornamento (tramite turbostream) della pagina
  # in questo modo non è necessario refreshare la pagina per mostrare nuovi messaggi
  after_create_commit { broadcast_append_to room }

  # validazione per il body
  validate :body
  validate :body_not_blank

  def confirm_participant
    # se non c'è un participant corretto, aborta creazione messaggio
    is_participant = Participant.where(user_id: user.id, room_id: room.id).first
    throw :abort unless is_participant
  end
  
  
  private

  def body_not_blank
    if body.blank?
      errors.add(:body, "non può essere vuoto")
    end
  end
end
