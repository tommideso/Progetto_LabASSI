class Menu < ApplicationRecord
    validates :titolo, :descrizione, :prezzo_persona, :min_persone, 
                :max_persone, :tipo_cucina, presence: true

    # per l'attributo booleano definisco il validates usando incluse per evitare problemi se è false
    validates :disattivato, inclusion: { in: [true, false] }
    # per extra e prezzo_extra definisco una validazione con un metodo 
    validate :prezzo_and_extra
    validate :max_persone_maggior_di_min_persone
    
    # collegamento verso prenotazione
    has_many :reservation

    # definiamo direttamente nel modello delle liste immutabili per la lista degli allergeni, le preferenze alimentari e il tipo di cucina
    # (così se vogliamo modificarli, li dobbiamo modificare solamente qua)
    # (il metodo freeze impedisce agli oggetti di essere modificati)
    PREFERENZE_ALIMENTARI = ["vegano", "glutine"].freeze
    ALLERGENI = ["glutine", "lattosio", "crostacei", "soia", "arachidi", "noci"].freeze
    TIPI_CUCINA = ["mare", "terra", "cinese", "indiano"].freeze
    EXTRA = ["vino", "mise en place"].freeze

    # immagini
    has_many_attached :images
    validate :images_must_be_valid
    
    # versioning tramite gemma paper_trail
    has_paper_trail on: [:update]

    # aggiungere metodo che specifichi quando fare versioning

    private

    def max_persone_maggior_di_min_persone
        # Verifica che entrambi i campi siano presenti prima di eseguire il confronto
        if max_persone.present? && min_persone.present? && max_persone < min_persone
            errors.add(:max_persone, "deve essere maggiore rispetto a min_persone")
        end
    end

    def prezzo_and_extra
        # se un extra è stato selezionato (quindi ci sta almeno uno con un valore true) e prezzo_extra è vuoto, restituisci errore
        if extra.values.any? { |value| value == "true" } && prezzo_extra.blank?
            errors.add(:prezzo_extra, "deve essere presente se selezioni un extra")
        # se il prezzo è stato inserito ma non ci sta nessun extra (non c'è ne sta nemmeno una true), restituisci errore
        elsif prezzo_extra.present? && !extra.values.any? { |value| value == "true" }
            errors.add(:extra, "deve avere almeno una selezione se ci sta un prezzo")
        end
    end

    def self.ransackable_attributes(auth_object = nil)
        ["allergeni", "descrizione", "titolo"]
    end
    
    # definiamo un metodo per verificare che si possono caricare solo immagini di tipo jpeg, png o gif
    def images_must_be_valid
        if images.attached?
          images.each do |image|
            if !image.content_type.in?(%w[image/jpeg image/png image/gif])
              errors.add(:images, 'must be a JPEG, PNG, or GIF')
            end
          end
        end
    end
end
