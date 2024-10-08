
class Reservation < ApplicationRecord
  belongs_to :client ## Chi ha prenotato
  belongs_to :chef ## Chi ha creato il menù
  # associazione rispetto il menu
  belongs_to :menu
  # usiamo un'associazione "personalizzata" con paper_trail
  belongs_to :menu_version, class_name: "PaperTrail::Version", optional: true
  # ed un'altra associata personalizzata con il solo scope di percorrere l'associazione in maniera più veloce
  has_one :versioned_menu, through: :menu_version, source: :item, source_type: "Menu", dependent: :destroy

  # aggiunta dell'associazione menu_version_id
  belongs_to :menu_version, optional: true

  # attesa_pagamento: appena prenoti e devi ancora pagare,
  # confermata: hai pagato,
  # completata: il menu è stato servito,
  # cancellata: chef o cliente hanno cancellato la prenotazione -> rimborso
  # rimborsata: il cliente ha chiesto il rimborso dopo che la prenotazione è stata completata
  enum stato: { attesa_pagamento: 0, confermata: 1, completata: 2, cancellata: 3, rimborsata: 4 }
  enum tipo_pasto: { colazione: 0, pranzo: 1, aperitivo: 2, cena: 3, altro: 4 }

  validates :num_persone, :tipo_pasto, :stato, :data_prenotazione, :indirizzo_consegna, :extra, presence: true

  # validates :tipo_pasto, presence: true

  # dopo la creazione di ogni prenotazione, 'salviamo' una versione del menù e la associamo alla prenotazione
  # salvandone la versione all'interno della colonna "menu_version_id"
  after_create :create_menu_version


  # Recensioni
  has_many :reviews, dependent: :destroy
  validate :max_three_reviews # non più di tre recensioni per prenotazione

  # Se il pagamento è stato effettuato, allora la prenotazione deve avere un session_id
  validates :stripe_payment_intent_id, presence: { message: "Deve essere presente il payment_intent_id se la prenotazione è confermata" }, if: -> { confermata? }



  # Chiavi per unica prenotazione attiva per cliente e giorno, e per chef e giorno se la prenotazione non è stata cancellata
  validates :client_id, uniqueness: { scope: :data_prenotazione, conditions: -> { where.not(stato: [ :cancellata, :rimborsata ]) }, message: "Esiste già una prenotazione per il cliente in questa data" }
  validates :chef_id, uniqueness: { scope: :data_prenotazione, conditions: -> { where.not(stato: [ :cancellata, :rimborsata ]) }, message: "Esiste già una prenotazione per lo chef in questa data" }

  validate :extra_must_be_valid

  private

  def create_menu_version
    Rails.logger.debug "Menu: #{menu.inspect}"
    if menu.present?
      Rails.logger.debug "Menu is present. Attempting to create version."

      if menu.valid?
        PaperTrail.request(enabled: true) do
          menu_version = menu.paper_trail.save_with_version

          Rails.logger.debug "Menu Version: #{menu_version.inspect}"

          if menu_version.present?
            update!(menu_version_id: menu_version.id)
          else
            Rails.logger.error "Menu version is nil. Cannot update reservation with menu version."
          end
          ultima_versione = menu.versions.find(menu_version.id)
          version_image = VersionImage.create!(version_id: ultima_versione.id)
          menu.images.each do |image|
            version_image.images.attach(image.blob)
          end
        end
      else
        Rails.logger.error "Menu is not valid: #{menu.errors.full_messages.join(", ")}"
      end
    else
      Rails.logger.error "Menu is nil. Cannot create menu version."
    end
  end

  # Verifica che non ci siano più di tre recensioni per prenotazione
  def max_three_reviews
    if reviews.size > 3
      errors.add(:base, "Ogni prenotazione può avere al massimo tre recensioni")
    end
  end

  def extra_must_be_valid
    if extra.present?
      extra.each do |key, value|
        unless Menu::EXTRA.include?(key)
          errors.add(:extra, "Chiave #{key} non valida")
        end
      end
    end
  end
end
