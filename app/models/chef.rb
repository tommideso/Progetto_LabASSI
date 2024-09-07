class Chef < ApplicationRecord
  belongs_to :user

  # validazione per i campi
  validates :telefono, :indirizzo, :raggio, :descrizione, presence: true
  validates :telefono, format: { with: /\A\+?[0-9\s\-()]+\z/, message: "formato telefono non valido" }

  has_many :menus, dependent: :destroy
  has_many :reservations, dependent: :destroy

  # Recensioni
  has_many :reviews, as: :tipo_recensione
end
