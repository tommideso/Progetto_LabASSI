class Client < ApplicationRecord
  belongs_to :user

  # validazione per i campi
  validates :allergeni, :indirizzo, :telefono, presence: true
  validates :telefono, format: { with: /\A\+?[0-9\s\-()]+\z/, message: "formato telefono non valido" }
end
