class Menu < ApplicationRecord
    validates :titolo, :descrizione, :prezzo_persona, :min_persone, 
                :max_persone, :tipo_cucina, presence: true

    # per l'attributo booleano definisco il validates usando incluse per evitare problemi se è false
    validates :disattivato, inclusion: { in: [true, false] }
    validates :prezzo_extra, presence: true, if: -> { extra_has_selected? }
    validates :extra, presence: true, if: -> { prezzo_extra.present? }

    validate :prezzo_extra_has_at_least_one_extra, if: -> { prezzo_extra.present? }

    # definiamo direttamente nel modello delle liste immutabili per la lista degli allergeni, le preferenze alimentari e il tipo di cucina
    # (così se vogliamo modificarli, li dobbiamo modificare solamente qua)
    # (il metodo freeze impedisce agli oggetti di essere modificati)
    PREFERENZE_ALIMENTARI = ["vegano", "glutine"].freeze
    ALLERGENI = ["glutine", "lattosio", "crostacei", "soia", "arachidi", "noci"].freeze
    TIPI_CUCINA = ["mare", "terra", "cinese", "indiano"].freeze
    EXTRA = ["vino", "mise en place"].freeze

    private

    def max_persone_maggior_di_min_persone
        # Verifica che entrambi i campi siano presenti prima di eseguire il confronto
        if max_persone.present? && min_persone.present? && max_persone < min_persone
            errors.add(:max_persone, "deve essere maggiore rispetto a min_persone")
        end
    end

    def prezzo_extra_has_at_least_one_extra
        # Verifica che almeno uno degli extra sia selezionato
        selected_extras = extra.select { |key, value| value == "true" }.keys
        unless (selected_extras & EXTRA).any?
            errors.add(:extra, "almeno uno degli extra deve essere selezionato")
        end
    end

    def extra_has_selected?
        extra.present? && extra.values.any? { |value| value == "true" }
    end
end
