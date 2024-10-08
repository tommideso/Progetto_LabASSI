class Menu < ApplicationRecord
    validates :titolo, :descrizione, :prezzo_persona, :min_persone,
                :max_persone, :tipo_cucina, :stripe_price_id, :stripe_product_id, presence: true


    # per l'attributo booleano definisco il validates usando incluse per evitare problemi se è false
    validates :disattivato, inclusion: { in: [ true, false ] }

    validate :max_persone_maggior_di_min_persone



    # collegamento verso chef
    belongs_to :chef
    # collegamento verso prenotazione
    has_many :reservations, dependent: :destroy


    # definiamo uno scope che restituisce i menu disponibili per una certa data, con stato della prenotazione :attesa_pagamento o :confermata
    # Mi basta sapere se c'è una prenotazione per quel giorno per lo chef
    scope :disponibili_per_data, ->(date) {
      where.not(chef_id: Reservation.where(data_prenotazione: date, stato: [ :attesa_pagamento, :confermata, :completata ]).select(:chef_id))
    }

    # definiamo direttamente nel modello delle liste immutabili per la lista degli allergeni, le preferenze alimentari e il tipo di cucina
    # (così se vogliamo modificarli, li dobbiamo modificare solamente qua)
    # (il metodo freeze impedisce agli oggetti di essere modificati)
    PREFERENZE_ALIMENTARI = [ "vegano", "glutine" ].freeze
    ALLERGENI = [ "glutine", "lattosio", "crostacei", "soia", "arachidi", "noci" ].freeze
    TIPI_CUCINA = [ "mare", "terra", "cinese", "indiano" ].freeze
    EXTRA = [ "vino", "miseenplace" ].freeze

    # immagini
    has_many_attached :images, dependent: :destroy
    validate :images_must_be_valid

    # versioning tramite gemma paper_trail
    has_paper_trail on: [] # normalmente la gemma è disabilitata! viene attivata dal modello reservation.rb

    # Recensioni
    has_many :reviews, as: :tipo_recensione, dependent: :destroy

    # Piatti
    has_many :dishes, dependent: :destroy
    accepts_nested_attributes_for :dishes, allow_destroy: true
    validate :must_have_at_least_one_dish

    # Definiamo un metodo per verificare che le chiavi dell'hash extra siano presenti nell'array EXTRA
    validate :validate_extra
    before_validation :set_default_extra

    private

    def max_persone_maggior_di_min_persone
        # Verifica che entrambi i campi siano presenti prima di eseguire il confronto
        if max_persone.present? && min_persone.present? && max_persone < min_persone
            errors.add(:max_persone, "deve essere maggiore rispetto a min_persone")
        end
    end

    # def prezzo_and_extra
    #     # se un extra è stato selezionato (quindi ci sta almeno uno con un valore true) e prezzo_extra è vuoto, restituisci errore
    #     if extra.values.any? { |value| value == "true" } && prezzo_extra.blank?
    #         errors.add(:prezzo_extra, "deve essere presente se selezioni un extra")
    #     # se il prezzo è stato inserito ma non ci sta nessun extra (non c'è ne sta nemmeno una true), restituisci errore
    #     elsif prezzo_extra.present? && !extra.values.any? { |value| value == "true" }
    #         errors.add(:extra, "deve avere almeno una selezione se ci sta un prezzo")
    #     end
    # end

    def self.ransackable_attributes(auth_object = nil)
        [ "allergeni", "preferenze_alimentari", "titolo", "min_persone", "max_persone" ]
    end
    def self.ransackable_associations(auth_object = nil)
        []
    end


    # definiamo un metodo per verificare che si possono caricare solo immagini di tipo jpeg, png o gif
    def images_must_be_valid
        if images.attached?
          images.each do |image|
            if !image.content_type.in?(%w[image/jpeg image/png image/gif])
              errors.add(:images, "must be a JPEG, PNG, or GIF")
            end
          end
        end
    end

    # definiamo un metodo per verificare che ci sia almeno un piatto
    def must_have_at_least_one_dish
        if dishes.empty? || dishes.nil?
            errors.add(:dishes, "Deve essere presente almeno un piatto")
        end
    end

    def validate_extra
        if extra.present?
            extra.each do |key, value|
                unless key.in?(EXTRA)
                    errors.add(:extra, "La chiave #{key} non è valida")
                end
            end
        end
    end

    def set_default_extra
        self.extra ||= EXTRA_KEYS.map { |key| [ key, 0 ] }.to_h
    end
end
