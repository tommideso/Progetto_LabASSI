class Menu < ApplicationRecord
    validates :titolo, :descrizione, :prezzo_persona, :min_persone, 
                :max_persone, :tipo_cucina, presence: true

    # per l'attributo booleano definisco il validates usando incluse per evitare problemi se è false
    validates :disattivato, inclusion: { in: [true, false] }

    validates :prezzo_extra, presence: true, if: -> { extra.present? }
    validates :extra, presence: true, if: -> { prezzo_extra.present? }
end
