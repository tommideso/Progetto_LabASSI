class Review < ApplicationRecord
  # Polymorphic significa che tipo_recensione può essere di qualunque tipo.
  # In questo caso, noi vogliamo che sia di tipo Menu, Chef o Client.
  # Quindi, se tipo_recensione_type è Menu, allora tipo_recensione_id sarà l'id di un Menu,
  # e tipo_recensione sarà un'istanza di Menu.
  belongs_to :tipo_recensione, polymorphic: true
  belongs_to :reservation

  validates :valutazione, presence: true, inclusion: { in: 1..5 }

  # La recensione Menu ha un commento, mentre la recensione Chef e Cliente no.
  # Quindi controllo tipo_recensione
  validates :commento, presence: true, if: -> { tipo_recensione_type == "Menu" }

  # Controllo che la recensione sia completata
  validate :reservation_completed

  # Controllo che ci sia una sola recensione per ogni tipo di recensione (Menu, Chef, Client) per ogni prenotazione
  validates :tipo_recensione_type, uniqueness: { scope: :reservation_id, message: "Esiste già una recensione di questo tipo per questa prenotazione" }
  private

  def reservation_completed
    unless reservation.present? && reservation.completata?
      errors.add(:reservation, "La prenotazione deve essere completata prima di effettuare una recensione")
    end
  end
end
