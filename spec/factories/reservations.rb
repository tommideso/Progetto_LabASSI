FactoryBot.define do
  factory :reservation do
    num_persone { 4 }  # Numero di persone
    tipo_pasto { :pranzo }  # Enum : colazione, pranzo, aperitivo, cena, altro
    extra { "Nessuna richiesta speciale" }  # Campo extra
    data_prenotazione { Date.today }  # Data prenotazione
    indirizzo_consegna { "Via Roma 1, Milano" }  # Indirizzo di consegna

    # Associazioni
    association :client  # Associazione con Client
    association :chef    # Associazione con Chef
    association :menu    # Associazione con Menu
  end
end
