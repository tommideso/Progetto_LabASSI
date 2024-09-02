class Client < ApplicationRecord
  belongs_to :user
  

  # validazione per i campi
  validates :indirizzo, :telefono, presence: true
  validates :telefono, format: { with: /\A\+?[0-9\s\-()]+\z/, message: "formato telefono non valido" }
  # validazione personalizzata per :allergeni (dato che è un jsbonb)
  validate :allergeni_presence

  has_many :reservations, dependent: :destroy
  has_many :favorites, dependent: :destroy

  private
  def allergeni_presence
    if allergeni.nil? || allergeni.empty? || allergeni.values.all?(&:blank?)
      errors.add(:allergeni, "can't be blank bro")
    end
  end
end
