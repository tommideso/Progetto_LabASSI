class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2] 

  # definiamo vincoli rispetto cliente e chef (has_one da parte di utente; belongs_to da parte di cliente e chef)
  # in questo modo ogni riga di cliente e chef si deve trovare in utente e ogni istanza di utente si trova al massimo in una di chef o client
  # usiamo dependent: :destroy per fare in modo che se un'istanza di utente viene eliminata, allora viene eliminata la relativa istanza di chef o client
  has_one :chef, dependent: :destroy
  has_one :client, dependent: :destroy
  # fondamentale definire gli attributi nestati perché cosi riusciamo a prendere, tramite helper fields_for, gli attributi di chef e cliente
  # come fossero "nestati" da dentro user!
  accepts_nested_attributes_for :chef
  accepts_nested_attributes_for :client

  # validazione per i campi
  validates :ruolo, inclusion: { in: ["chef", "client", "admin", nil] }
  validate :ruolo_presente_se_inizializzato
  validate :nome_e_cognome_presenti_se_ruolo_selezionato_o_completato

  # metodi per determinare i ruoli
  def chef?
    ruolo == "chef"
  end
  def client?
    ruolo == "client"
  end
  def admin?
    ruolo == "admin"
  end

  # funzione per fare retrieving dei dati sugli utenti loggati tramite oauth
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.avatar_url = auth.info.image
      user.confirmed_at = Time.now
      user.nome = auth.info.name.split(" ")[0].capitalize
      user.cognome = auth.info.name.split(" ")[1 .. -1].join(" ").capitalize

      # campi extra come nome e ruolo vengono impostati nella fase di completamento anche per gli utenti registrati da oauth
      # user.ruolo = nil # PER ORA HARDCODIAMO IL RUOLO PERCHÉ NON C'È UNA PAGINA SEPARATA! TODO
      # user.inizializzato = true
    end
  end

  private

  def nome_e_cognome_presenti_se_ruolo_selezionato_o_completato
    errors.add(:base, "Nome, cognome devono essere presenti") if (completed == 1 || completed == 2) && (nome.blank? || cognome.blank?)
  end

  def ruolo_presente_se_inizializzato
    errors.add(:base, "Il ruolo deve essere presente") if (completed==0) && (ruolo.blank?)
  end
end
