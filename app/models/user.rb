class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # definiamo vincoli rispetto cliente e chef (has_one da parte di utente; belongs_to da parte di cliente e chef)
  # in questo modo ogni riga di cliente e chef si deve trovare in utente e ogni istanza di utente si trova al massimo in una di chef o client
  # usiamo dependent: :destroy per fare in modo che se un'istanza di utente viene eliminata, allora viene eliminata la relativa istanza di chef o client
  has_one :chef, dependent: :destroy
  has_one :client, dependent: :destroy

  # validazione per i campi
  validates :ruolo, presence: true
  validates :ruolo, inclusion: { in: ["chef", "client", "admin"] }

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
end
