class Menu < ApplicationRecord
    validates :titolo, :descrizione, :prezzo_persona, :min_persone, 
                :max_persone, :tipo_cucina, presence: true

    # per l'attributo booleano definisco il validates usando incluse per evitare problemi se è false
    validates :disattivato, inclusion: { in: [true, false] }
    validates :prezzo_extra, presence: true, if: -> { extra.present? }
    validates :extra, presence: true, if: -> { prezzo_extra.present? }

    # validazione personalizzata per fare in modo che max_persone sia maggiore di min_persone
    validate :max_persone_maggior_di_min_persone

    # definiamo direttamente nel modello delle liste immutabili per la lista degli allergeni, le preferenze alimentari e il tipo di cucina
    # (così se vogliamo modificarli, li dobbiamo modificare solamente qua)
    # (il metodo freeze impedisce agli oggetti di essere modificati)
    PREFERENZE_ALIMENTARI = ["vegano", "glutine"].freeze
    ALLERGENI = ["glutine", "lattosio", "crostacei", "soia", "arachidi", "noci"].freeze
    TIPI_CUCINA = ["mare", "terra", "cinese", "indiano"].freeze
    EXTRA = ["vino", "mise en place"].freeze

    # NOTA: interpretiamo 'adattabile' come un dizionario con due chiavi ('preferenze' e 'allergeni') e per ognuna di queste chiavi si va
    # a definire l'adattabilità per ogni possibili valore


    private

    def max_persone_maggior_di_min_persone
        if (max_persone < min_persone)
            errors.add(:max_persone, "deve essere maggiore rispetto di min persone")
        end
    end
end
