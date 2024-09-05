class Client < ApplicationRecord
  belongs_to :user


  # validazione per i campi
  validates :indirizzo, :telefono, presence: true
  validates :telefono, format: { with: /\A\+?[0-9\s\-()]+\z/, message: "formato telefono non valido" }
  # validazione personalizzata per :allergeni (dato che è un jsbonb)
  validate :allergeni_presence

  has_many :reservations, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # Recensioni
  has_many :reviews, as: :tipo_recensione

  delegate :email, to: :user
  pay_customer stripe_attributes: :stripe_attributes


  def first_name
    user.nome
  end

  def last_name
    user.cognome
  end

  private
  def allergeni_presence
    if allergeni.nil? || allergeni.empty? || allergeni.values.all?(&:blank?)
      errors.add(:allergeni, "can't be blank bro")
    end
  end

  def stripe_attributes(pay_customer)
    {
      # address: {
      #   add: pay_customer.owner.indirizzo,
      # },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: user.id
      }
    }
  end
end
