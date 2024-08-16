class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # definiamo vincoli rispetto cliente e chef (has_one da parte di utente; belongs_to da parte di cliente e chef)
  # in questo modo ogni riga di cliente e chef si deve trovare in utente e ogni istanza di utente si trova al massimo in una di chef o client
  has_one :chef
  has_one :client

end
