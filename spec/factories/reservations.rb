#INUSATO DA BUTTARE penso
FactoryBot.define do
  factory :reservation do
    num_persone { 4 }
    tipo_pasto { :pranzo }
    extra { "Nessuna richiesta speciale" }
    data_prenotazione { Date.today }
    indirizzo_consegna { "Via Roma 1, Milano" }

    # Associazioni
    association :client
    
    # Definisci la factory per il menu con lo chef associato
    association :menu, factory: :menu_with_chef

    # Dopo la creazione della prenotazione
    after(:create) do |reservation|
      # Associa il menu con lo stesso chef della prenotazione
      reservation.update(chef: reservation.menu.chef)

      # Debugging: Stampa le informazioni
      puts "Created reservation: #{reservation.inspect}"
      puts "Associated chef: #{reservation.chef.inspect}"
      puts "Associated menu chef: #{reservation.menu.chef.inspect}"
    end
  end

  factory :menu_with_chef, parent: :menu do
    association :chef
  end
end

