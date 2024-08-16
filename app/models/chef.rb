class Chef < ApplicationRecord
  belongs_to :user

  # validazione per i campi
  validates :telefono, :indirizzo, :raggio, :descrizione, :bloccato, presence: true
  validates :telefono, format: { with: /\A\+?[0-9\s\-()]+\z/, message: "formato telefono non valido" }
  validates :bloccato, inclusion: { in: [true, false] }
end
