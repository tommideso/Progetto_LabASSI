require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:client) { create(:client) }
  let(:chef) { create(:chef) }
  let(:menu) { create(:menu) }
  let(:reservation) { Reservation.create!(
    num_persone: 4,
    tipo_pasto: :pranzo,
    extra: 'vino false mise en place true',
    menu_id: menu.id,
    client_id: client.id,
    chef_id: menu.chef.id,
    data_prenotazione: '2024-10-01',
    indirizzo_consegna: 'Via Esempio 123') 
    }
  # let(:reservation2) { create(:reservation, client: client, chef: chef, data_prenotazione: '2024-09-12') }

    it 'ensures the chef of the reservation matches the chef of the menu' do
      expect(reservation.chef).to eq(reservation.menu.chef)
    end

  #   # it 'ensures the chef of the reservation matches the chef of the menu' do
  #   #   expect(reservation2.chef).to eq(reservation2.menu.chef)
  #   # end

  context 'uniqueness validation' do
    # Crea una prenotazione esistente con dati specifici. Questa prenotazione viene usata per verificare la regola di unicità.
    let!(:existing_reservation) { Reservation.create!(
      num_persone: 4,
      tipo_pasto: :pranzo,
      extra: 'vino false mise en place true',
      menu_id: menu.id,
      client_id: client.id,
      chef_id: menu.chef.id,
      data_prenotazione: '2024-12-10',
      indirizzo_consegna: 'Via Esempio 123',
      stato: "confermata" ,
      stripe_payment_intent_id: Faker::Alphanumeric.alphanumeric(number: 20),
    )}
    # Crea una nuova prenotazione (non salvata nel database) con lo stesso cliente e data della prenotazione esistente. Verifica che questa prenotazione non sia valida
    # il cliente non può avere più di una prenotazione nella stessa data
    it 'does not allow multiple reservations for the same client on the same day' do
      new_reservation = Reservation.new(
        num_persone: 4,
        tipo_pasto: :pranzo,
        extra: 'vino false mise en place true',
        menu_id: create(:menu).id,
        client_id: client.id,
        chef_id: create(:chef).id,
        data_prenotazione: '2024-12-10',
        indirizzo_consegna: 'Via Esempio 123'
      )
      expect(new_reservation.save).to be_falsey
      expect(new_reservation.errors[:client_id]).to include("Esiste già una prenotazione per il cliente in questa data")
    end
    
    # Lo chef non puo avere le stesse prenotazioni nello stesso giorno se sono nello stato confermata o attesa pagamento
    it 'does not allow multiple reservations for the same chef on the same day' do
      new_reservation = Reservation.new(
        num_persone: 4,
        tipo_pasto: :pranzo,
        extra: 'vino false mise en place true',
        menu_id: menu.id,
        client_id: create(:client).id,
        chef_id: menu.chef.id,
        data_prenotazione: '2024-12-10',
        indirizzo_consegna: 'Via Esempio 123',
      )
      expect(new_reservation.save).to be_falsey
      expect(new_reservation.errors[:chef_id]).to include("Esiste già una prenotazione per lo chef in questa data")
    end
  end

  #   validates :num_persone, :tipo_pasto, :stato, :data_prenotazione, :indirizzo_consegna, :extra, presence: true
  it "is not valid without num_persone" do
    reservation = Reservation.new(num_persone: nil, tipo_pasto: "pranzo", stato: "confermata", data_prenotazione: Date.today, indirizzo_consegna: "via roma 1", extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without tipo_pasto" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: nil, stato: "confermata", data_prenotazione: Date.today, indirizzo_consegna: "via roma 1", extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without stato" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: "pranzo", stato: nil, data_prenotazione: Date.today, indirizzo_consegna: "via roma 1", extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without data_prenotazione" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: "pranzo", stato: "confermata", data_prenotazione: nil, indirizzo_consegna: "via roma 1", extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without indirizzo_consegna" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: "pranzo", stato: "confermata", data_prenotazione: Date.today, indirizzo_consegna: nil, extra: "extra")
    expect(reservation).to_not be_valid
  end

  it "is not valid without extra" do
    reservation = Reservation.new(num_persone: 2, tipo_pasto: "pranzo", stato: "confermata", data_prenotazione: Date.today, indirizzo_consegna: "via roma 1", extra: nil)
    expect(reservation).to_not be_valid
  end


  
end
