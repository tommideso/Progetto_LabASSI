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
  validates :ruolo, presence: true
  validates :ruolo, inclusion: { in: ["chef", "client", "admin"] }
  validate :nome_e_cognome_presenti_se_inizializzato_o_completato

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
      user.inizializzato = true
      user.nome = auth.info.name.split(" ")[0]
      user.cognome = auth.info.name.split(" ")[1 .. -1].join(" ")

      # campi extra come nome e ruolo vengono impostati nella fase di completamento anche per gli utenti registrati da oauth
      user.ruolo = "client" # PER ORA HARDCODIAMO IL RUOLO PERCHÉ NON C'È UNA PAGINA SEPARATA! TODO
    end
  end

  private

  def nome_e_cognome_presenti_se_inizializzato_o_completato
    errors.add(:base, "Nome e cognome devono essere presenti") if (inizializzato || completed) && (nome.blank? || cognome.blank?)
  end
end
