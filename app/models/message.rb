class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  # fondamentale affinché ogni messaggio porti ad un aggiornamento (tramite turbostream) della pagina
  # in questo modo non è necessario refreshare la pagina per mostrare nuovi messaggi
  after_create_commit {broadcast_append_to self.room }
end
