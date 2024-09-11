class Dish < ApplicationRecord
  belongs_to :menu

  # Facoltativo: validazione per il campo tipo_portata
  validates :tipo_portata, inclusion: { in: [ "Antipasto", "Primo", "Secondo", "Dolce" ] }
  validates :nome, :tipo_portata, :ingredienti, presence: true
end
